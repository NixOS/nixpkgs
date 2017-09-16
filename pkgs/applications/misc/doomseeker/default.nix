{ stdenv, cmake, fetchurl, pkgconfig, qt4, zlib, bzip2 }:

stdenv.mkDerivation rec {
  name = "doomseeker-1.1";

  src = fetchurl {
    url = "http://doomseeker.drdteam.org/files/${name}_src.tar.bz2";
    sha256 = "0nmq8s842z30ngzikrmfx0xpnk4klxdv37y26chs002rnj010r7h";
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
