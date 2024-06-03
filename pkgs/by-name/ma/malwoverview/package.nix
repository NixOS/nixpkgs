{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "malwoverview";
  version = "5.4.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "alexandreborges";
    repo = "malwoverview";
    rev = "refs/tags/v${version}";
    hash = "sha256-eP2xYd/S/c4Z/cdK8IWghEUyF7pSTb5Cpg5pS/tpzUI=";
  };

  pythonRemoveDeps = [
    "pathlib"
  ];

  nativeBuildInputs = with python3.pkgs; [
    pythonRelaxDepsHook
  ];

  build-system  = with python3.pkgs; [
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
