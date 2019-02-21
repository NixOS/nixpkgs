{ stdenv, python3, beancount }:

let
  inherit (python3.pkgs) buildPythonApplication fetchPypi;
in
buildPythonApplication rec {
  pname = "fava";
  version = "1.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "115r99l6xfliafgkpcf0mndqrvijix5mflg2i56s7xwqr3ch8z9k";
  };

  doCheck = false;

  propagatedBuildInputs = with python3.pkgs;
    [ 
      Babel
      cheroot
      flaskbabel
      flask
      jinja2
      beancount
      click
      markdown2
      ply
      simplejson
    ];

  meta = {
    homepage = https://beancount.github.io/fava;
    description = "Web interface for beancount";
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ matthiasbeyer ];
  };
}
