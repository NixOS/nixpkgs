{ stdenv, cmake, fetchurl, pkgconfig, qt4, zlib, bzip2 }:

stdenv.mkDerivation rec {
  name = "doomseeker-0.12.2b";
  src = fetchurl {
    url = "http://doomseeker.drdteam.org/files/${name}_src.tar.bz2";
    sha256 = "1bcrxc3g9c6b4d8dbm2rx0ldxkqc5fc91jndkwiaykf8hajm0jnr";
  };

  cmakeFlags = ''
    -DCMAKE_BUILD_TYPE=Release
  '';

  buildInputs = [ cmake pkgconfig qt4 zlib bzip2 ];

  enableParallelBuilding = true;

  patchPhase = ''
    sed -e 's#/usr/share/applications#$out/share/applications#' -i src/core/CMakeLists.txt
  '';

  meta = {
    homepage = http://doomseeker.drdteam.org/;
    description = "Multiplayer server browser for many Doom source ports";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ MP2E ];
  };
}

