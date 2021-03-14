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
  version = "2.7";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "jrnl-org";
    repo = pname;
    rev = "v${version}";
    sha256 = "1hyjjw9mxy73n3pkliaaif135h2sd4iy43pw9d5zynid5abnr3yz";
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
