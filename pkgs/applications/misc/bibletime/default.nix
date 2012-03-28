{stdenv, fetchurl, cmake, sword, qt4, boost, cluceneCore}:

stdenv.mkDerivation rec {

  version = "2.9.1";

  name = "bibletime-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/bibletime/${name}.tar.bz2";
    sha256 = "1d8kh213rpx4d63sxl5mk1s94xv363l5prrq2kh06cpnl7a8d2ih";
  };

  prePatch = ''
    patchShebangs .;
  '';

  preConfigure =  ''
    export CLUCENE_HOME=${cluceneCore};
    export SWORD_HOME=${sword};
  '';

  buildInputs = [ cmake sword qt4 boost cluceneCore ];

  cmakeFlags = "-DUSE_QT_WEBKIT=ON -DCMAKE_BUILD_TYPE=Debug";

  meta = {
    description = "A Qt4 Bible study tool";
    homepage = http://www.bibletime.info/;
    platforms = stdenv.lib.platforms.linux;
    license = "GPLv2";
    maintainers = [ stdenv.lib.maintainers.piotr ];
  };
}
