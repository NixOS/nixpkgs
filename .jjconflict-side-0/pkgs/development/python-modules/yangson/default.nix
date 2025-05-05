{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  elementpath,
  pyyaml,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "yangson";
  version = "1.6.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "CZ-NIC";
    repo = "yangson";
    tag = version;
    hash = "sha256-gGunbQVRV9cFRnwGDIaGi/NM75rtw5vYVz2PiPiZlQo=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    elementpath
    pyyaml
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "yangson" ];

  meta = with lib; {
    description = "Library for working with data modelled in YANG";
    mainProgram = "yangson";
    homepage = "https://github.com/CZ-NIC/yangson";
    license = with licenses; [
      gpl3Plus
      lgpl3Plus
    ];
    maintainers = [ ];
  };
}
