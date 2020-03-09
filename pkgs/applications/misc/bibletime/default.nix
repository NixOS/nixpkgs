{ stdenv, fetchurl, cmake, pkgconfig, sword, boost, clucene_core
, qtbase, qttools, qtsvg, qtwebkit
}:

stdenv.mkDerivation rec {

  version = "2.11.2";

  pname = "bibletime";

  src = fetchurl {
    url = "mirror://sourceforge/bibletime/${pname}-${version}.tar.xz";
    sha256 = "1s5bvmwbz1gyp3ml8sghpc00h8nhdvx2iyq96iri30kwx1y1jy6i";
  };

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [
   sword boost clucene_core
   qtbase qttools qtsvg qtwebkit
 ];

  preConfigure =  ''
    export CLUCENE_HOME=${clucene_core};
    export SWORD_HOME=${sword};
  '';

  cmakeFlags = [ "-DUSE_QT_WEBKIT=ON" "-DCMAKE_BUILD_TYPE=Debug" ];

  meta = {
    description = "A Qt4 Bible study tool";
    homepage = http://www.bibletime.info/;
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.piotr ];
  };
}
