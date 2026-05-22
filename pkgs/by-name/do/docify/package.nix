{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "docify";
  version = "1.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "atoerien";
    repo = "docify";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xp8VsDv2Wf8g2mUMPmBgWoyWpJna/r1xPgqO3SUqcR0=";
  };

  build-system = with python3Packages; [
    hatchling
  ];

  dependencies = with python3Packages; [
    libcst
    tqdm
  ];

  pythonImportsCheck = [ "docify" ];

  # upstream has no tests
  doCheck = false;

  meta = {
    changelog = "https://github.com/atoerien/docify/releases/tag/v${finalAttrs.version}";
    description = "Script to add docstrings to Python type stubs using reflection";
    homepage = "https://github.com/atoerien/docify";
    license = lib.licenses.mit;
    mainProgram = "docify";
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
