{stdenv, fetchurl, cmake, sword, qt4, boost, clucene_core}:

stdenv.mkDerivation rec {

  version = "2.10.1";

  name = "bibletime-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/bibletime/${name}.tar.xz";
    sha256 = "14fayy5h1ffjxin669q56fflxn4ij1irgn60cygwx2y02cwxbll6";
  };

  prePatch = ''
    patchShebangs .;
  '';

  preConfigure =  ''
    export CLUCENE_HOME=${clucene_core};
    export SWORD_HOME=${sword};
  '';

  buildInputs = [ cmake sword qt4 boost clucene_core ];

  cmakeFlags = "-DUSE_QT_WEBKIT=ON -DCMAKE_BUILD_TYPE=Debug";

  meta = {
    description = "A Qt4 Bible study tool";
    homepage = http://www.bibletime.info/;
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.piotr ];
  };
}
