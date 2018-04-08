{ stdenv, python3, beancount }:

let
  inherit (python3.pkgs) buildPythonApplication fetchPypi;
in
buildPythonApplication rec {
  pname = "fava";
  version = "1.6";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0iif4imx76ra0lsisksrq5vf54wbivnrb3xqz6mkx9lik3pp5sbx";
  };

  doCheck = false;

  propagatedBuildInputs = with python3.pkgs;
    [ flask dateutil pygments wheel markdown2 flaskbabel tornado
      click beancount ];

  meta = {
    homepage = https://beancount.github.io/fava;
    description = "Web interface for beancount";
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ ];
  };
}

