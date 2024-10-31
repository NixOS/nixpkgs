{
  lib,
  python3Packages,
  fetchFromGitHub,
  versionCheckHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "cpplint";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cpplint";
    repo = "cpplint";
    rev = "refs/tags/${version}";
    hash = "sha256-076363ZwcriPb+Fn9S5jay8oL+LlBTNh+IqQRCAndRo=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace-fail "pytest-cov" "" \
      --replace-fail "--cov-fail-under=90 --cov=cpplint" ""
  '';

  build-system = with python3Packages; [
    setuptools
  ];

  nativeCheckInputs = with python3Packages; [
    parameterized
    pytestCheckHook
    pytest-timeout
    testfixtures
    versionCheckHook
  ];
  versionCheckProgramArg = [ "--version" ];

  meta = {
    homepage = "https://github.com/cpplint/cpplint";
    description = "Static code checker for C++";
    changelog = "https://github.com/cpplint/cpplint/releases/tag/${version}";
    mainProgram = "cpplint";
    maintainers = [ lib.maintainers.bhipple ];
    license = [ lib.licenses.bsd3 ];
  };
}
