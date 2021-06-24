{ lib
, ansiwrap
, asteval
, buildPythonApplication
, colorama
, cryptography
, fetchFromGitHub
, keyring
, parsedatetime
, poetry
, pytestCheckHook
, python-dateutil
, pytz
, pyxdg
, pyyaml
, tzlocal
}:

buildPythonApplication rec {
  pname = "jrnl";
  version = "2.8";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "jrnl-org";
    repo = pname;
    rev = "v${version}";
    sha256 = "1zpsvrjhami9y7204yjbdzi04bkkz6i3apda9fh3hbq83y6wzprz";
  };

  nativeBuildInputs = [ poetry ];

  propagatedBuildInputs = [
    ansiwrap
    asteval
    colorama
    cryptography
    keyring
    parsedatetime
    python-dateutil
    pytz
    pyxdg
    pyyaml
    tzlocal
  ];

  checkInputs = [ pytestCheckHook ];
  pythonImportsCheck = [ "jrnl" ];

  meta = with lib; {
    homepage = "http://maebert.github.io/jrnl/";
    description = "A simple command line journal application that stores your journal in a plain text file";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ zalakain ];
  };
}
