{
  fetchFromGitHub,
  lib,
  python3Packages,
  versionCheckHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "archey4";
  version = "4.15.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "HorlogeSkynet";
    repo = "archey4";
    tag = "v${finalAttrs.version}";
    hash = "sha256-R3Pb5gS/xpQdR1OjQKIL83w+BCvvp0In2roJVCN769E=";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    distro
    netifaces
  ];

  pythonImportsCheck = [ "archey" ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "Maintained fork of the original Archey (Linux) system tool";
    homepage = "https://github.com/HorlogeSkynet/archey4";
    changelog = "https://github.com/HorlogeSkynet/archey4/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "archey";
  };
})
