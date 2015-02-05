{ stdenv, fetchurl, cmake, qt4, pkgconfig, neon, qtkeychain, sqlite }:

stdenv.mkDerivation rec {
  name = "owncloud-client" + "-" + version;

  version = "1.7.1";

  src = fetchurl {
    url = "https://download.owncloud.com/desktop/stable/mirall-${version}.tar.bz2";
    sha256 = "0n9gv97jqval7xjyix2lkywvmvvfv052s0bd1i8kybdl9rwca6yf";
  };

  buildInputs =
    [ cmake qt4 pkgconfig neon qtkeychain sqlite];

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
