{
  python3Packages,
  fetchFromGitHub,
  lib,
}:

python3Packages.buildPythonApplication rec {
  pname = "mnamer";
  version = "2.6.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "jkwill87";
    repo = "mnamer";
    tag = version;
    sha256 = "sha256-lu1DWbR7LkaRddeAAHBWM61cnEZG4KVZdQWWRsbghb8=";
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

  patches = [
    # https://github.com/jkwill87/mnamer/pull/291
    ./cached_session_error.patch
  ];

  nativeCheckInputs = [ python3Packages.pytestCheckHook ];

  # disable test that fail (networking, etc)
  disabledTests = [
    "network"
    "e2e"
    "test_utils.py"
  ];

  meta = with lib; {
    homepage = "https://github.com/jkwill87/mnamer";
    description = "Intelligent and highly configurable media organization utility";
    mainProgram = "mnamer";
    license = licenses.mit;
    maintainers = with maintainers; [ urlordjames ];
  };
}
