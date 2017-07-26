{ stdenv, cmake, fetchurl, pkgconfig, qt4, zlib, bzip2 }:

stdenv.mkDerivation rec {
  name = "doomseeker-1.0";

  src = fetchurl {
    url = "http://doomseeker.drdteam.org/files/${name}_src.tar.bz2";
    sha256 = "172ybxg720r64hp6aah0hqvxklqv1cf8v7kwx0ng5ap0h20jydbw";
  };

  buildInputs = [ qt4 zlib bzip2 ];

  nativeBuildInputs = [ cmake pkgconfig ];

  enableParallelBuilding = true;

  patchPhase = ''
    substituteInPlace src/core/CMakeLists.txt --replace /usr/share/applications "$out"/share/applications
  '';

  meta = with stdenv.lib; {
    homepage = http://doomseeker.drdteam.org/;
    description = "Multiplayer server browser for many Doom source ports";
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = [ maintainers.MP2E ];
  };
}
