{
  lib,
  python3Packages,
  fetchFromGitHub,
  versionCheckHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "nvitop";
  version = "1.5.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "XuehaiPan";
    repo = "nvitop";
    tag = "v${version}";
    hash = "sha256-cqRvjK3q9fm5HPnZFGSV59FPnAdLkeq/D5wSR5ke7Ok=";
  };

  build-system = with python3Packages; [ setuptools ];

  pythonRelaxDeps = [ "nvidia-ml-py" ];

  dependencies = with python3Packages; [
    psutil
    nvidia-ml-py
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";

  pythonImportsCheck = [ "nvitop" ];

  meta = {
    description = "Interactive NVIDIA-GPU process viewer, the one-stop solution for GPU process management";
    homepage = "https://github.com/XuehaiPan/nvitop";
    changelog = "https://github.com/XuehaiPan/nvitop/releases/tag/v${version}";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    platforms = with lib.platforms; linux;
  };
}
