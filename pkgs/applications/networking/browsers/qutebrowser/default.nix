{ stdenv, fetchgit, python, buildPythonPackage, qt5, pyqt5, jinja2, pygments, pyyaml, pypeg2,
  gst_plugins_base, gst_plugins_good, gst_ffmpeg }:

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

  propagatedBuildInputs = [
    python pyyaml pyqt5 jinja2 pygments pypeg2
  ];

  makeWrapperArgs = ''
    --prefix GST_PLUGIN_PATH : "${stdenv.lib.makeSearchPath "lib/gstreamer-0.10"
       [ gst_plugins_base gst_plugins_good gst_ffmpeg ]}"
    --prefix QT_PLUGIN_PATH : "${qt5.multimedia}/lib/qt5/plugins"
  '';

  meta = {
    homepage = https://github.com/The-Compiler/qutebrowser;
    description = "Keyboard-focused browser with a minimal GUI";
    license = stdenv.lib.licenses.gpl3Plus;
    maintainers = [ stdenv.lib.maintainers.jagajaga ];
  };
}
