{ stdenv, pythonPackages, fetchgit }:

pythonPackages.buildPythonApplication rec {
  name = "leo-editor-${version}";
  namePrefix = "";
  version = "5.1";

  src = fetchgit {
    url = "https://github.com/leo-editor/leo-editor";
    rev = "refs/tags/Leo-${version}-final";
    sha256 = "0km5mvzfpfbxxhcjr4if24qhgk2c7dsvmfinz0zrbfriip848vcp";
  };

  propagatedBuildInputs = with pythonPackages; [ pyqt4 sqlite3 ];


  patchPhase = ''
    rm setup.cfg
  '';

  meta = {
    homepage = "http://leoeditor.com";
    description = "A powerful folding editor";
    longDescription = "Leo is a PIM, IDE and outliner that accelerates the work flow of programmers, authors and web designers.";
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ leonardoce ];
  };
}
