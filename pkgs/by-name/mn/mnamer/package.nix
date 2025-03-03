{
  python3Packages,
  fetchFromGitHub,
  fetchpatch,
  lib,
}:

python3Packages.buildPythonApplication rec {
  pname = "mnamer";
  version = "2.5.5";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "jkwill87";
    repo = "mnamer";
    rev = version;
    sha256 = "sha256-qQu5V1GOsbrR00HOrot6TTAkc3KRasBPDEU7ZojUBio=";
  };

  build-system = with python3Packages; [
    setuptools
    setuptools-scm
  ];

  nativeBuildInputs = with python3Packages; [ pythonRelaxDepsHook ];

  propagatedBuildInputs = with python3Packages; [
    appdirs
    babelfish
    guessit
    requests
    requests-cache
    teletype
  ];

  pythonRelaxDeps = [
    "guessit"
    "requests-cache"
    "setuptools-scm"
    "typing-extensions"
  ];

  patches = [
    # https://github.com/jkwill87/mnamer/pull/291
    (fetchpatch {
      name = "fix-cached-session-object-error";
      url = "https://patch-diff.githubusercontent.com/raw/jkwill87/mnamer/pull/291.patch";
      hash = "sha256-b0mD9lLE0cUy3kk6Y04MjJfBXSj8HDApmo4xoBINAwA=";
    })
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
