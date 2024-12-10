{
  lib,
  buildPythonApplication,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  testfixtures,
}:

buildPythonApplication rec {
  pname = "bump2version";
  version = "1.0.1";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "c4urself";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-j6HKi3jTwSgGBrA8PCJJNg+yQqRMo1aqaLgPGf4KAKU=";
  };

  nativeCheckInputs = [
    pytestCheckHook
    testfixtures
  ];

  disabledTests = [
    # X's in pytest are git tests which won't run in sandbox
    "usage_string_fork"
    "test_usage_string"
    "test_defaults_in_usage_with_config"
  ];

  pythonImportsCheck = [ "bumpversion" ];

  meta = with lib; {
    description = "Version-bump your software with a single command";
    longDescription = ''
      A small command line tool to simplify releasing software by updating
      all version strings in your source code by the correct increment.
    '';
    homepage = "https://github.com/c4urself/bump2version";
    license = licenses.mit;
    maintainers = with maintainers; [ jefflabonte ];
  };
}
