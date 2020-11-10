{ stdenv, python3, beancount }:

let
  inherit (python3.pkgs) buildPythonApplication fetchPypi;
in
buildPythonApplication rec {
  pname = "fava";
  version = "1.16";

  src = fetchPypi {
    inherit pname version;
    sha256 = "436b6f9441a638f8028729c2a39c28433f7878c2af6ddb9bfccaeea9ea3086e1";
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
  # the entry_slices and render_entries requires other files to pass
  checkPhase = ''
    py.test tests -k 'not cli and not static_url and not entry_slice and not render_entries'
  '';

  meta = {
    homepage = "https://beancount.github.io/fava";
    description = "Web interface for beancount";
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ matthiasbeyer ];
  };
}
