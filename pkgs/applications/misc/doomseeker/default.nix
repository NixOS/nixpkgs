{ stdenv, cmake, fetchurl, pkgconfig, qt4, zlib, bzip2 }:

stdenv.mkDerivation rec {
  name = "doomseeker-0.12.1b";
  src = fetchurl {
    url = "http://doomseeker.drdteam.org/files/${name}_src.tar.bz2";
    sha256 = "110yg3w3y1x8p4gqpxb6djxw348caj50q5liq8ssb5mf78v8gk6b";
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
    maintainers = with stdenv.lib.maintainers; [ MP2E ];
  };
}

