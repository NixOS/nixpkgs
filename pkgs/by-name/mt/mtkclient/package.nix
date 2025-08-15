{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "mtkclient";
  version = "2.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bkerler";
    repo = "mtkclient";
    # No tag for this has been created, but the version in pyproject.toml was bumped.
    rev = "1ffb152766eafeae07724ab76651dad2f8bb484b";
    hash = "sha256-po/wrJ74m36P3qCIWUDFvu9V8pLqxk8eFR3y8ziQMcA=";
  };

  build-system = [ python3Packages.setuptools ];

  dependencies = with python3Packages; [
    colorama
    fusepy
    hatchling
    mock
    pycryptodome
    pycryptodomex
    pyserial
    pyside6
    pyusb
    shiboken6
  ];

  pythonImportsCheck = [ "mtkclient" ];

  meta = {
    description = "MTK reverse engineering and flash tool";
    homepage = "https://github.com/bkerler/mtkclient";
    mainProgram = "mtk";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.timschumi ];
  };
}
