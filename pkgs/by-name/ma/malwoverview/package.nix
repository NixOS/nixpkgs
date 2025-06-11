{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "malwoverview";
  version = "6.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "alexandreborges";
    repo = "malwoverview";
    tag = "v${version}";
    hash = "sha256-43LcrP89vhVFDRRRItFL6hl++mvdGoPugMwD3TEOSE0=";
  };

  pythonRemoveDeps = [
    "pathlib"
  ];

  build-system = with python3.pkgs; [
    setuptools
  ];

  dependencies = with python3.pkgs; [
    colorama
    configparser
    geocoder
    pefile
    polyswarm-api
    python-magic
    requests
    simplejson
    validators
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "malwoverview"
  ];

  meta = {
    description = "Tool for threat hunting and gathering intel information from various sources";
    homepage = "https://github.com/alexandreborges/malwoverview";
    changelog = "https://github.com/alexandreborges/malwoverview/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "malwoverview.py";
  };
}
