{ lib, python3Packages }:

python3Packages.buildPythonApplication rec {
  version = "0.8.2";
  pname = "gita";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "16jpnl323x86dkrnh4acyvi9jknhgi3r0ccv63rkjcmd0srkaxkk";
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
