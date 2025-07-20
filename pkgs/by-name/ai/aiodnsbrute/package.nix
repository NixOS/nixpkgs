{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "aiodnsbrute";
  version = "0.3.3";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "blark";
    repo = "aiodnsbrute";
    tag = "v${version}";
    hash = "sha256-cEpk71VoQJZfKeAZummkk7yjtXKSMndgo0VleYiMlWE=";
  };

  build-system = with python3.pkgs; [
    setuptools
  ];

  dependencies = with python3.pkgs; [
    aiodns
    click
    tqdm
    uvloop
  ];

  # Project no tests
  doCheck = false;

  pythonImportsCheck = [
    "aiodnsbrute.cli"
  ];

  meta = {
    description = "DNS brute force utility";
    mainProgram = "aiodnsbrute";
    homepage = "https://github.com/blark/aiodnsbrute";
    changelog = "https://github.com/blark/aiodnsbrute/releases/tag/v${version}";
    license = with lib.licenses; [ gpl3Only ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
