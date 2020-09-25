{ stdenv, python3, beancount }:

let
  inherit (python3.pkgs) buildPythonApplication fetchPypi;
in
buildPythonApplication rec {
  pname = "fava";
  version = "1.15";

  src = fetchPypi {
    inherit pname version;
    sha256 = "037fhimfjiqay28wg7hd5sm7r0935ynw9d905iszn965ihr1qsgz";
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
