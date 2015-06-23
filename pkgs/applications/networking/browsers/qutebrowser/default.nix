{ stdenv, fetchurl, python, buildPythonPackage, qt5, pyqt5, jinja2, pygments, pyyaml, pypeg2}:

let version = "0.2.1"; in

buildPythonPackage {
  name = "qutebrowser-${version}";
  namePrefix = "";
  
  src = fetchurl {
    url = "https://github.com/The-Compiler/qutebrowser/releases/download/v${version}/qutebrowser-${version}.tar.gz";
    sha256 = "b741a1a0336b8d36133603a3318d1c4c63c9abf50212919200cd2ae665b07111";
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
  };
}
