{ stdenv, fetchurl, buildPythonPackage, pythonPackages, pygtk }:

buildPythonPackage {
  name = "keepnote-0.7.8";
  namePrefix = "";

  src = fetchurl {
    url = "http://keepnote.org/download/keepnote-0.7.8.tar.gz";
    sha256 = "0nhkkv1n0lqf3zn17pxg5cgryv1wwlj4hfmhixwd76rcy8gs45dh";
  };

  propagatedBuildInputs = [ pythonPackages.sqlite3 pygtk ];

  # Testing fails.
  doCheck = false;

  meta = {
    description = "Note taking application";
    homepage = http://rasm.ods.org/keepnote;
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
