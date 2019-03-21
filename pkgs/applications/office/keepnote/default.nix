{ stdenv, fetchurl, python2Packages }:

python2Packages.buildPythonApplication {
  name = "keepnote-0.7.8";
  namePrefix = "";

  src = fetchurl {
    url = "http://keepnote.org/download/keepnote-0.7.8.tar.gz";
    sha256 = "0nhkkv1n0lqf3zn17pxg5cgryv1wwlj4hfmhixwd76rcy8gs45dh";
  };

  propagatedBuildInputs = with python2Packages; [ pyGtkGlade ];

  # Testing fails.
  doCheck = false;

  meta = {
    description = "Note taking application";
    homepage = http://keepnote.org;
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
