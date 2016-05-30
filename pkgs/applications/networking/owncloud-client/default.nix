{ stdenv, fetchurl, cmake, qt4, pkgconfig, qtkeychain, sqlite }:

stdenv.mkDerivation rec {
  name = "owncloud-client" + "-" + version;

  version = "2.2.0";

  src = fetchurl {
    url = "https://download.owncloud.com/desktop/stable/owncloudclient-${version}.tar.xz";
    sha256 = "1ak7hq13hl7qndm3zz7hdfvw6930kmhjh27s1427g784vxcqb23q";
  };

  buildInputs =
    [ cmake qt4 pkgconfig qtkeychain sqlite];

  #configurePhase = ''
  #  mkdir build
  #  cd build
  #  cmake -DBUILD_WITH_QT4=on \
  #        -DCMAKE_INSTALL_PREFIX=$out \
  #        -DCMAKE_BUILD_TYPE=Release \
  #        ..
  #'';

  enableParallelBuilding = true;

  meta = {
    description = "Synchronise your ownCloud with your computer using this desktop client";
    homepage = https://owncloud.org;
    maintainers = with stdenv.lib.maintainers; [ qknight ];
    meta.platforms = stdenv.lib.platforms.unix;
  };
}
