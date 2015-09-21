{ stdenv, fetchgit, python, buildPythonPackage, qt5, pyqt5, jinja2, pygments, pyyaml, pypeg2 }:

let version = "0.4.0"; in

buildPythonPackage {
  name = "qutebrowser-${version}";
  namePrefix = "";

  src = fetchgit {
    url = "https://github.com/The-Compiler/qutebrowser.git";
    rev = "e11fcda240eaad1b83b26c7d6424c427d2ad3b96";
    sha256 = "0hpd6fibzcl0s6jrsj60rs12dyliwr05r8h9wvngh19a3pmg8q74";
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
