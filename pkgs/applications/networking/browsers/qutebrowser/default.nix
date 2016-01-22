{ stdenv, fetchurl, python, buildPythonPackage, qtmultimedia, pyqt5
, jinja2, pygments, pyyaml, pypeg2, gst-plugins-base, gst-plugins-good
, gst-plugins-bad, gst-libav, wrapGAppsHook, glib_networking }:

let version = "0.5.0"; in

buildPythonPackage rec {
  name = "qutebrowser-${version}";
  namePrefix = "";

  src = fetchurl {
    url = "https://github.com/The-Compiler/qutebrowser/releases/download/v${version}/${name}.tar.gz";
    sha256 = "16cyw0jg6qg9ksr6xwgnkm1a2bwgii2s35nrgk3g705ywfsf02j7";
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
