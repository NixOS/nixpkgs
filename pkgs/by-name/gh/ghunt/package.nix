{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "ghunt";
  version = "2.0.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "mxrch";
    repo = "ghunt";
    rev = "refs/tags/v${version}";
    hash = "sha256-7awLKX+1fVbufg3++lUUCZg4p07c2yGeefiPFcE1Ij4=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    alive-progress
    autoslot
    beautifulsoup4
    beautifultable
    geopy
    httpx
    humanize
    imagehash
    inflection
    jsonpickle
    pillow
    protobuf
    python-dateutil
    rich
    trio
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "ghunt"
  ];

  meta = with lib; {
    description = "Offensive Google framework";
    homepage = "https://github.com/mxrch/ghunt";
    changelog = "https://github.com/mxrch/GHunt/releases/tag/v${version}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
