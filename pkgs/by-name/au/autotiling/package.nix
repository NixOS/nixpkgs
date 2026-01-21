{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "autotiling";
  version = "1.9.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nwg-piotr";
    repo = "autotiling";
    tag = "v${finalAttrs.version}";
    hash = "sha256-k+UiAGMB/fJiE+C737yGdyTpER1ciZrMkZezkcn/4yk=";
  };

  build-system = [
    python3Packages.setuptools
  ];

  dependencies = [
    python3Packages.i3ipc
    python3Packages.importlib-metadata
  ];
  doCheck = false;

  meta = {
    homepage = "https://github.com/nwg-piotr/autotiling";
    description = "Script for sway and i3 to automatically switch the horizontal / vertical window split orientation";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ artturin ];
    mainProgram = "autotiling";
  };
})
