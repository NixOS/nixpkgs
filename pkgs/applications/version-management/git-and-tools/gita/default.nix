{ lib
, buildPythonApplication
, fetchPypi
, pyyaml
, setuptools
}:

buildPythonApplication rec {
  version = "0.9.9";
  pname = "gita";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1si2f9nyisbrvv8cvrjxj8r4cbrgc97ic0wdlbf34gvp020dsmgv";
  };

  propagatedBuildInputs = [
    pyyaml
    setuptools
  ];

  meta = with lib; {
    description = "A command-line tool to manage multiple git repos";
    homepage = https://github.com/nosarthur/gita;
    license = licenses.mit;
    maintainers = with maintainers; [ seqizz ];
  };
}
