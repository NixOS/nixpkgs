{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "malwoverview";
  version = "8.0.1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "alexandreborges";
    repo = "malwoverview";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yIlKrZaIJmz3INGTrk+ydU+8gjAt54glSteMUrXSAgU=";
  };

  pythonRemoveDeps = [
    "pathlib"
  ];

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    colorama
    configparser
    geocoder
    pefile
    polyswarm-api
    python-magic
    requests
    simplejson
    validators
    tqdm
    python-whois
    ipwhois
    # For --tui
    textual
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "malwoverview"
  ];

  meta = {
    description = "Tool for threat hunting and gathering intel information from various sources";
    homepage = "https://github.com/alexandreborges/malwoverview";
    changelog = "https://github.com/alexandreborges/malwoverview/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "malwoverview.py";
  };
})
