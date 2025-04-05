{
  lib,
  python3Packages,
  fetchFromGitHub,
  versionCheckHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "cpplint";
  version = "2.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cpplint";
    repo = "cpplint";
    tag = version;
    hash = "sha256-IM1XznnpdL1Piei9kKR1nCwfs7TVgLcTgMI4r+cQXLg=";
  };

  # We use pytest-cov-stub instead
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"pytest-cov",' ""
  '';

  build-system = with python3Packages; [
    setuptools
  ];

  nativeCheckInputs = with python3Packages; [
    parameterized
    pytest-cov-stub
    pytest-timeout
    pytestCheckHook
    testfixtures
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";

  meta = {
    homepage = "https://github.com/cpplint/cpplint";
    description = "Static code checker for C++";
    changelog = "https://github.com/cpplint/cpplint/releases/tag/${version}";
    mainProgram = "cpplint";
    maintainers = [ lib.maintainers.bhipple ];
    license = [ lib.licenses.bsd3 ];
  };
}
