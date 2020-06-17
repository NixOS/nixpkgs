{ lib
, buildPythonApplication
, fetchPypi
, pyyaml
, setuptools
}:

buildPythonApplication rec {
  version = "0.10.5";
  pname = "gita";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1xggslmrrfszpl190klkc97fnl88gml1bnkmkzp6aimdch66g4jg";
  };

  propagatedBuildInputs = [
    pyyaml
    setuptools
  ];

  meta = with lib; {
    description = "A command-line tool to manage multiple git repos";
    homepage = "https://github.com/nosarthur/gita";
    license = licenses.mit;
    maintainers = with maintainers; [ seqizz ];
  };
}
