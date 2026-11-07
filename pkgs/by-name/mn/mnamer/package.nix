{
  lib,
  python3Packages,
  fetchFromGitHub,
  versionCheckHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "mnamer";
  version = "2.7.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jkwill87";
    repo = "mnamer";
    tag = finalAttrs.version;
    hash = "sha256-GH5HTN8JjvYDKuiqSNsv6Nbmj1ERNyQN+qPDKcpY0fI=";
  };

  build-system = with python3Packages; [
    setuptools
    setuptools-scm
  ];

  dependencies = with python3Packages; [
    appdirs
    babelfish
    guessit
    requests
    requests-cache
    teletype
  ];

  pythonRelaxDeps = true;

  nativeCheckInputs = [
    python3Packages.pytestCheckHook
    versionCheckHook
  ];

  # disable test that fail (networking, etc)
  disabledTests = [
    "network"
    "e2e"
    "test_utils.py"
  ];

  meta = {
    homepage = "https://github.com/jkwill87/mnamer";
    description = "Intelligent and highly configurable media organization utility";
    mainProgram = "mnamer";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.quantenzitrone ];
  };
})
