{ stdenv, pythonPackages, fetchgit }:

pythonPackages.buildPythonApplication rec {
  name = "leo-editor-${version}";
  namePrefix = "";
  version = "5.1";

  src = fetchgit {
    url = "https://github.com/leo-editor/leo-editor";
    rev = "refs/tags/Leo-${version}-final";
    sha256 = "3cc5259609890bbde9cfee71f4f60b959b3f5b740f7d403c99ea2d9796b4758e";
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
