{ stdenv, python3, beancount }:

let
  inherit (python3.pkgs) buildPythonApplication fetchPypi;
in
buildPythonApplication rec {
  pname = "fava";
  version = "1.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0bxnh977r821b8vy36z81k40pazbxspx4wa9sp4ppanx7cha9sy4";
  };

  doCheck = false;

  propagatedBuildInputs = with python3.pkgs;
    [ flask dateutil pygments wheel markdown2 flaskbabel tornado
      click beancount uritemplate httplib2 Babel ];

  meta = {
    homepage = https://beancount.github.io/fava;
    description = "Web interface for beancount";
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ matthiasbeyer ];
  };
}

