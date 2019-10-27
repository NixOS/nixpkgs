{ stdenv, fetchurl, mkDerivation, cmake, pkgconfig, qtbase, qtwebkit, qtkeychain, sqlite }:

mkDerivation rec {
  pname = "owncloud-client";
  version = "2.5.4.11654";

  src = fetchurl {
    url = "https://download.owncloud.com/desktop/stable/owncloudclient-${version}.tar.xz";
    sha256 = "0gsnry0786crbnpgg3f1vcqw6mwbz6svhm6mw3767qi4lb33jm31";
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
