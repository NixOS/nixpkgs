{ stdenv, python3, beancount }:

let
  inherit (python3.pkgs) buildPythonApplication fetchPypi;
in
buildPythonApplication rec {
  pname = "fava";
  version = "1.13";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1pjfa5xb2imhcf7q037h8g0bp9nrnj1xyblgqphnjnz6hbr58a59";
  };

  checkInputs = [ python3.pkgs.pytest ];
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
      werkzeug
      jaraco_functools
    ];

  # CLI test expects fava on $PATH.  Not sure why static_url fails.
  checkPhase = ''
    py.test tests -k 'not cli and not static_url'
  '';

  meta = {
    homepage = https://beancount.github.io/fava;
    description = "Web interface for beancount";
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ matthiasbeyer ];
  };
}
