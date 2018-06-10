{ stdenv, fetchurl, cmake, pkgconfig, qtbase, qtwebkit, qtkeychain, sqlite }:

stdenv.mkDerivation rec {
  name = "owncloud-client-${version}";
  version = "2.4.1";

  src = fetchurl {
    url = "https://download.owncloud.com/desktop/stable/owncloudclient-${version}.tar.xz";
    sha256 = "4462ae581c281123dc62f3604f1aa54c8f4a60cd8157b982e2d76faac0f7aa23";
  };

  patches = [ ./find-sql.patch ];

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
  };
}
