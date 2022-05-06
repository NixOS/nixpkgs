{ lib
, python3
}:

with python3.pkgs;

buildPythonApplication rec {
  pname = "ablog";
  version = "0.10.24";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-bLpINvEH7B/duSRrfzvq25se0mvbbcxaEcAs8xMw6Kc=";
  };

  propagatedBuildInputs = [
    feedgen
    sphinx
    invoke
    watchdog
    python-dateutil
  ];

  checkInputs = [
    pytestCheckHook
  ];

  nativeBuildInputs = [ setuptools-scm ];

  meta = with lib; {
    description = "ABlog for blogging with Sphinx";
    homepage = "https://ablog.readthedocs.io/en/latest/";
    license = licenses.mit;
    maintainers = with maintainers; [ rgrinberg ];
  };
}
