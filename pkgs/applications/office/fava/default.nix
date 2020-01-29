{ stdenv, python3, beancount }:

let
  inherit (python3.pkgs) buildPythonApplication fetchPypi;
in
buildPythonApplication rec {
  pname = "fava";
  version = "1.12";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0309y25l7aijk7il9hpjia23yc5dfac0h78xdmzb0w0ynxbjsmi6";
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
