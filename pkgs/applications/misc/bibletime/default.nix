{stdenv, fetchurl, cmake, sword, qt4, boost, clucene_core}:

stdenv.mkDerivation rec {

  version = "2.9.2";

  name = "bibletime-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/bibletime/${name}.tar.bz2";
    sha256 = "1j4kc24qvhqlbqspczmkxvw09mnvgg9m4zs1y9f68505kd0pfg1r";
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
