{ stdenv, fetchurl, mkDerivation, cmake, pkgconfig, qtbase, qtwebkit, qtkeychain, sqlite }:

mkDerivation rec {
  pname = "owncloud-client";
  version = "2.6.0.13018";

  src = fetchurl {
    url = "https://download.owncloud.com/desktop/stable/owncloudclient-${version}.tar.xz";
    sha256 = "0dhz4wmpda32qyghjihqnwhrslk0yxhgny2dqbyi5b6gpj3353p7";
  };

  nativeBuildInputs = [ pkgconfig cmake ];
  buildInputs = [ qtbase qtwebkit qtkeychain sqlite ];

  cmakeFlags = [
    "-UCMAKE_INSTALL_LIBDIR"
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Synchronise your ownCloud with your computer using this desktop client";
    homepage = https://owncloud.org;
    maintainers = [ maintainers.qknight ];
    platforms = platforms.unix;
    license = licenses.gpl2Plus;
  };
}
