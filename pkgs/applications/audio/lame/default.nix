{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "lame-3.96.1";
  src = fetchurl {
    url = http://mesh.dl.sourceforge.net/sourceforge/lame/lame-3.96.1.tar.gz ;
    md5 = "e1206c46a5e276feca11a7149e2fc6ac" ;
  };
}
