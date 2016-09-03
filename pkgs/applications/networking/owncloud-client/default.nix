{ stdenv, fetchurl, cmake, qt4, pkgconfig, qtkeychain, sqlite }:

stdenv.mkDerivation rec {
  name = "owncloud-client" + "-" + version;

  version = "2.2.3";

  src = fetchurl {
    url = "https://download.owncloud.com/desktop/stable/owncloudclient-${version}.tar.xz";
    sha256 = "00bx9wrgvbdhi9vx30qfgkdz0k8nxlj313pac34cchx5xpij3jgq";
  };

  buildInputs =
    [ cmake qt4 pkgconfig qtkeychain sqlite];

  cmakeFlags = [
  "-UCMAKE_INSTALL_LIBDIR"
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Synchronise your ownCloud with your computer using this desktop client";
    homepage = https://owncloud.org;
    maintainers = with stdenv.lib.maintainers; [ qknight ];
    meta.platforms = stdenv.lib.platforms.unix;
  };
}
