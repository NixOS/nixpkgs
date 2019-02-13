{ lib, python3Packages }:

python3Packages.buildPythonApplication rec {
  version = "0.7.3";
  pname = "gita";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "0ccqjf288513im7cvafiw4ypbp9s3z0avyzd4jzr13m38jrsss3r";
  };

  propagatedBuildInputs = with python3Packages; [
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
