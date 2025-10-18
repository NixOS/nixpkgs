{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication {
  pname = "mtkclient";
  version = "2.0.1-unstable-2025-09-26";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bkerler";
    repo = "mtkclient";
    rev = "399b3a1c25e73ddf4951f12efd20f7254ee04a39";
    hash = "sha256-XNPYeVhp5P+zQdumS9IzlUd5+WebL56qcgs10WS2/LY=";
  };

  build-system = [ python3Packages.hatchling ];

  dependencies = with python3Packages; [
    colorama
    fusepy
    pycryptodome
    pycryptodomex
    pyserial
    pyside6
    pyusb
    shiboken6
  ];

  pythonImportsCheck = [ "mtkclient" ];

  postInstall = ''
    mkdir -p $out/lib/udev/rules.d
    cp $src/mtkclient/Setup/Linux/*.rules $out/lib/udev/rules.d
  '';

  meta = {
    description = "MTK reverse engineering and flash tool";
    homepage = "https://github.com/bkerler/mtkclient";
    mainProgram = "mtk";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.timschumi ];
  };
}
