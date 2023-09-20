{ lib
, fetchPypi
, python3Packages
}:

python3Packages.buildPythonApplication rec {
  pname = "acpic";
  version = "1.0.0";
  format = "setuptools";

  src = fetchPypi {
    inherit version pname;
    hash = "sha256-vQ9VxCNbOmqHIY3e1wq1wNJl5ywfU2tm62gDg3vKvcg=";
  };

  nativeBuildInputs = [
    python3Packages.pbr
  ];

  # no tests
  doCheck = false;

  meta = with lib; {
    description = "Daemon extending acpid event handling capabilities.";
    homepage = "https://github.com/psliwka/acpic";
    license = licenses.wtfpl;
    maintainers = with maintainers; [ aacebedo ];
  };
}
