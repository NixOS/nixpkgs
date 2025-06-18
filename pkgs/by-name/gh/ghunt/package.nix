{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "ghunt";
  version = "2.3.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mxrch";
    repo = "ghunt";
    # The newer releases aren't git-tagged to we just take the
    # commit with the version bump
    rev = "5782248bfd92a24875e112ed0a83e6986d4c70d0";
    hash = "sha256-SQk/hy4r9LIffsu3kxLTv5LCcEvcZkP2jhmPA6Fzo8U=";
  };

  pythonRelaxDeps = true;

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
  ];

  propagatedBuildInputs =
    with python3.pkgs;
    [
      alive-progress
      autoslot
      beautifulsoup4
      beautifultable
      dnspython
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
      rich-argparse
      packaging
    ]
    ++ httpx.optional-dependencies.http2;

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "ghunt"
  ];

  meta = {
    description = "Offensive Google framework";
    mainProgram = "ghunt";
    homepage = "https://github.com/mxrch/ghunt";
    changelog = "https://github.com/mxrch/GHunt/releases/tag/v${version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ fab ];
  };
}
