{ lib, buildPythonApplication, fetchPypi, pythonAtLeast, pillow, pyqt5, psutil
, python-slugify, raven
}:

buildPythonApplication rec {
  pname = "kcc";
  version = "5.5.1";

  src = fetchPypi {
    inherit version;
    pname = "KindleComicConverter";
    sha256 = "5dbee5dc5ee06a07316ae5ebaf21ffa1970094dbae5985ad735e2807ef112644";
  };

  disabled = !(pythonAtLeast "3.3");
  propagatedBuildInputs = [ pillow pyqt5 psutil python-slugify raven ];

  meta = {
    description = "Python app to convert comic/manga files or folders to EPUB, Panel View MOBI or E-Ink optimized CBZ";
    homepage = "https://kcc.iosphe.re";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ dawidsowa ];
  };
}
