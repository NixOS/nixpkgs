{ stdenv, fetchgit, python, buildPythonPackage, qtmultimedia, pyqt5
, jinja2, pygments, pyyaml, pypeg2, gst-plugins-base, gst-plugins-good
, gst-plugins-bad, gst-libav, wrapGAppsHook, glib_networking }:

let version = "0.4.1"; in

buildPythonPackage {
  name = "qutebrowser-${version}";
  namePrefix = "";

  src = fetchgit {
    url = "https://github.com/The-Compiler/qutebrowser.git";
    rev = "8d9e9851f1dcff5deb6363586ad0f1edec040b72";
    sha256 = "1qsdad10swnk14qw4pfyvb94y6valhkscyvl46zbxxs7ck6llsm2";
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
