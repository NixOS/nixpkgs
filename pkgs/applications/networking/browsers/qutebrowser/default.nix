{ stdenv, fetchFromGitHub, python, buildPythonApplication, qtmultimedia, pyqt5
, jinja2, pygments, pyyaml, pypeg2, gst-plugins-base, gst-plugins-good
, gst-plugins-bad, gst-libav, wrapGAppsHook, glib_networking }:

let version = "0.6.2"; in

buildPythonApplication rec {
  name = "qutebrowser-${version}";
  namePrefix = "";

  src = fetchFromGitHub {
    owner = "The-Compiler";
    repo = "qutebrowser";
    rev = "v${version}";
  };

  # Needs tox
  doCheck = false;

  buildInputs = [ wrapGAppsHook
    gst-plugins-base gst-plugins-good gst-plugins-bad gst-libav
    glib_networking ];

  propagatedBuildInputs = [
    python pyyaml pyqt5 jinja2 pygments pypeg2
  ];

  makeWrapperArgs = ''
    --prefix QT_PLUGIN_PATH : "${qtmultimedia}/lib/qt5/plugins"
  '';

  meta = {
    homepage = https://github.com/The-Compiler/qutebrowser;
    description = "Keyboard-focused browser with a minimal GUI";
    license = stdenv.lib.licenses.gpl3Plus;
    maintainers = with stdenv.lib.maintainers; [ jagajaga fpletz ];
  };
}
