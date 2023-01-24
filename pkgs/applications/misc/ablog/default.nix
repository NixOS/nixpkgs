{ lib
, python3
}:

with python3.pkgs;

buildPythonApplication rec {
  pname = "ablog";
  version = "0.10.33";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-vCkLX64aPAem0QvKI1iUNAHWEJZlAOIb1DA9U7xPJkU=";
  };

  propagatedBuildInputs = [
    feedgen
    sphinx
    invoke
    watchdog
    python-dateutil
  ];

  nativeCheckInputs = [
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
