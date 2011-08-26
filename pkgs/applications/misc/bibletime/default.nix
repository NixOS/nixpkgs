{stdenv, fetchurl, cmake, sword, qt4, boost, cluceneCore}:

stdenv.mkDerivation rec {

  version = "2.7.3";

  name = "bibletime-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/bibletime/${name}.tar.bz2";
    sha256 = "0171hlwg4rjv93b3gwcyv3nsj2kzwf4n8f6jw6ld18x7xmk9rkdg";
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
  };

}

