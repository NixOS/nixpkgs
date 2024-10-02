{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "ghunt";
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mxrch";
    repo = "ghunt";
    rev = "refs/tags/v${version}";
    hash = "sha256-UeHVATTyAH3Xdm/NVSUhiicM+tZ4UnLeJsy1jSLK3v8=";
  };

  pythonRelaxDeps = true;

  nativeBuildInputs = with python3.pkgs; [
    setuptools
  ];

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
    packaging
  ] ++ httpx.optional-dependencies.http2;

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "ghunt"
  ];

  meta = with lib; {
    description = "Offensive Google framework";
    mainProgram = "ghunt";
    homepage = "https://github.com/mxrch/ghunt";
    changelog = "https://github.com/mxrch/GHunt/releases/tag/v${version}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
