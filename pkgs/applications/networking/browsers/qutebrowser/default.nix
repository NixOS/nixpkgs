{ stdenv, fetchgit, python, buildPythonPackage, qt5, pyqt5, jinja2, pygments, pyyaml, pypeg2 }:

let version = "0.3-pre"; in

buildPythonPackage {
  name = "qutebrowser-${version}";
  namePrefix = "";

  src = fetchgit {
    url = "https://github.com/The-Compiler/qutebrowser.git";
    rev = "f31f254d9bf3ffd4ef95089f4924e5c45d8c0f78";
    sha256 = "0virh71q9qyh7ggk5p6h3gjv30gr2jn8am6yq8xzbslchck0rkcr";
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
