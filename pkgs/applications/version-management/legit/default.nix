{ lib
, python3Packages
, fetchPypi
}:

python3Packages.buildPythonApplication rec {
  pname = "legit";
  version = "1.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ngh3ar6v15516f52j21k6qz7hykmxfjadhb2rakvl27b5xvjy1c";
  };

  propagatedBuildInputs = with python3Packages; [
    click
    clint
    crayons
    gitpython
    six
  ];

  # no tests
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/frostming/legit";
    description = "Git for Humans, Inspired by GitHub for Mac";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ryneeverett ];
    mainProgram = "legit";
  };
}
