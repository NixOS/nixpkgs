{ stdenv, fetchurl, python, buildPythonApplication, qtmultimedia, pyqt5
, jinja2, pygments, pyyaml, pypeg2, gst-plugins-base, gst-plugins-good
, gst-plugins-bad, gst-libav, wrapGAppsHook, glib_networking, makeQtWrapper }:

let version = "0.8.1"; in

buildPythonApplication rec {
  name = "qutebrowser-${version}";
  namePrefix = "";

  src = fetchurl {
    url = "https://github.com/The-Compiler/qutebrowser/releases/download/v${version}/${name}.tar.gz";
    sha256 = "18hj95pgybpavwwnyczh6s94spljfngz684y1jlhqnpbp14pkflh";
  };

  # Needs tox
  doCheck = false;

  buildInputs = [ wrapGAppsHook makeQtWrapper
    qtmultimedia
    gst-plugins-base gst-plugins-good gst-plugins-bad gst-libav
    glib_networking ];

  propagatedBuildInputs = [
    python pyyaml pyqt5 jinja2 pygments pypeg2
  ];

  postInstall = ''
    mv $out/bin/qutebrowser $out/bin/.qutebrowser-noqtpath
    makeQtWrapper $out/bin/.qutebrowser-noqtpath $out/bin/qutebrowser
  '';

  meta = {
    homepage = https://github.com/The-Compiler/qutebrowser;
    description = "Keyboard-focused browser with a minimal GUI";
    license = stdenv.lib.licenses.gpl3Plus;
    maintainers = [ stdenv.lib.maintainers.jagajaga ];
  };
}
