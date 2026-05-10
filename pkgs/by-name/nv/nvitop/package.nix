{
  lib,
  python3Packages,
  fetchFromGitHub,
  versionCheckHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "nvitop";
  version = "1.6.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "XuehaiPan";
    repo = "nvitop";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CaQO20PF/fVGybyrt2OGASYsKAJsmJkOGis1ff/OOIs=";
  };

  build-system = with python3Packages; [ setuptools ];

  pythonRelaxDeps = [ "nvidia-ml-py" ];

  dependencies = with python3Packages; [
    psutil
    nvidia-ml-py
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  pythonImportsCheck = [ "nvitop" ];

  meta = {
    description = "Interactive NVIDIA-GPU process viewer, the one-stop solution for GPU process management";
    homepage = "https://github.com/XuehaiPan/nvitop";
    changelog = "https://github.com/XuehaiPan/nvitop/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    platforms = with lib.platforms; linux;
  };
})
