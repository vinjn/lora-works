$Env:HF_HOME = "huggingface"
$Env:PIP_DISABLE_PIP_VERSION_CHECK = 1
$Env:PIP_NO_CACHE_DIR = 1
$Env:PIP_INDEX_URL = "https://mirror.baidu.com/pypi/simple"
function InstallFail {
    Write-Output "��װʧ�ܡ�"
    Read-Host | Out-Null ;
    Exit
}

function Check {
    param (
        $ErrorInfo
    )
    if (!($?)) {
        Write-Output $ErrorInfo
        InstallFail
    }
}

if (!(Test-Path -Path "venv")) {
    Write-Output "���ڴ������⻷��..."
    python -m venv venv
    Check "�������⻷��ʧ�ܣ����� python �Ƿ�װ����Լ� python �汾�Ƿ�Ϊ64λ�汾��python 3.10����python��Ŀ¼�Ƿ��ڻ�������PATH�ڡ�"
}

.\venv\Scripts\activate
Check "�������⻷��ʧ�ܡ�"

Set-Location .\sd-scripts
Write-Output "��װ������������ (�ѽ��й��ڼ��٣����ڹ�����޷�ʹ�ü���Դ�뻻�� install.ps1 �ű�)"
$install_torch = Read-Host "�Ƿ���Ҫ��װ Torch+xformers? [y/n] (Ĭ��Ϊ y)"
if ($install_torch -eq "y" -or $install_torch -eq "Y" -or $install_torch -eq ""){
    pip install torch==2.0.0+cu118 torchvision==0.15.1+cu118 -f https://mirror.sjtu.edu.cn/pytorch-wheels/torch_stable.html -i https://mirror.baidu.com/pypi/simple
    Check "torch ��װʧ�ܣ���ɾ�� venv �ļ��к��������С�"
    pip install -U -I --no-deps xformers==0.0.19
    Check "xformers ��װʧ�ܡ�"
}

pip install --upgrade -r requirements.txt
Check "sd-scripts ������װʧ�ܡ�"

Write-Output "��װ bitsandbytes..."
cp .\bitsandbytes_windows\*.dll ..\venv\Lib\site-packages\bitsandbytes\
cp .\bitsandbytes_windows\cextension.py ..\venv\Lib\site-packages\bitsandbytes\cextension.py
cp .\bitsandbytes_windows\main.py ..\venv\Lib\site-packages\bitsandbytes\cuda_setup\main.py

Set-Location ..
pip install --upgrade -r requirements.txt
Check "ѵ������������װʧ�ܡ�"

Write-Output "��װ���"
Read-Host | Out-Null ;
