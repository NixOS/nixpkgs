{ stdenv, fetchurl, python, buildPythonApplication, qtmultimedia, pyqt5
, jinja2, pygments, pyyaml, pypeg2, gst-plugins-base, gst-plugins-good
, gst-plugins-bad, gst-libav, wrapGAppsHook, glib_networking }:

let version = "0.6.0"; in

buildPythonApplication rec {
  name = "qutebrowser-${version}";
  namePrefix = "";

  src = fetchurl {
    url = "https://github.com/The-Compiler/qutebrowser/releases/download/v${version}/${name}.tar.gz";
    sha256 = "1vf9gh1f12wza72y3yqj568h2wsm7wfvjjs6qsh6apw5mgjysz91";
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
    maintainers = [ stdenv.lib.maintainers.jagajaga ];
  };
}
