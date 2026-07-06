{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "aiodnsbrute";
  version = "0.3.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "blark";
    repo = "aiodnsbrute";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cEpk71VoQJZfKeAZummkk7yjtXKSMndgo0VleYiMlWE=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
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
    changelog = "https://github.com/blark/aiodnsbrute/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [ gpl3Only ];
    maintainers = with lib.maintainers; [ fab ];
  };
})
