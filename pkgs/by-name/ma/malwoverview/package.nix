{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "malwoverview";
  version = "6.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "alexandreborges";
    repo = "malwoverview";
    rev = "refs/tags/v${version}";
    hash = "sha256-N9jXMkX3Kt3ldw/QgJRAE2ItrzjXzQthQ9UULRtnN0A=";
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

  meta = with lib; {
    description = "Tool for threat hunting and gathering intel information from various sources";
    homepage = "https://github.com/alexandreborges/malwoverview";
    changelog = "https://github.com/alexandreborges/malwoverview/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
    mainProgram = "malwoverview.py";
  };
}
