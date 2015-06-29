{ stdenv, fetchgit, python, buildPythonPackage, qt5, pyqt5, jinja2, pygments, pyyaml, pypeg2 }:

let version = "0.3"; in

buildPythonPackage {
  name = "qutebrowser-${version}";
  namePrefix = "";

  src = fetchgit {
    url = "https://github.com/The-Compiler/qutebrowser.git";
    rev = "b3cd31a808789932a0a4cb7aa8d9280b6d3a12e7";
    sha256 = "fea7fd9de8a930da7af0111739ae88851cb965b30751858d1aba5bbd15277652";
  };

  # Needs tox
  doCheck = false;

  propagatedBuildInputs = [
    python pyyaml pyqt5 jinja2 pygments pypeg2
  ];

  meta = {
    homepage = https://github.com/The-Compiler/qutebrowser;
    description = "Keyboard-focused browser with a minimal GUI";
    license = stdenv.lib.licenses.gpl3Plus;
    maintainers = [ stdenv.lib.maintainers.jagajaga ];
  };
}
