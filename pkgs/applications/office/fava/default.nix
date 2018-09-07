{ stdenv, python3, beancount }:

let
  inherit (python3.pkgs) buildPythonApplication fetchPypi;
in
buildPythonApplication rec {
  pname = "fava";
  version = "1.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c4eba4203bddaa7bc9d54971d2afeeebab0bc80ce89be1375a41a07c4e82b62f";
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
