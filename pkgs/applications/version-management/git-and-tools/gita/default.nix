{ lib
, buildPythonApplication
, fetchPypi
, pyyaml
}:

buildPythonApplication rec {
  version = "0.9.2";
  pname = "gita";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1aycqq4crsa57ghpv7xc497rf4y8x43fcfd0v9prd2kn6h1793r0";
  };

  propagatedBuildInputs = [
    pyyaml
  ];

  doCheck = false;  # Releases don't include tests

  meta = with lib; {
    description = "A command-line tool to manage multiple git repos";
    homepage = https://github.com/nosarthur/gita;
    license = licenses.mit;
    maintainers = with maintainers; [ seqizz ];
  };
}
