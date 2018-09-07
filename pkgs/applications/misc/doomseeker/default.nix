{ stdenv, cmake, fetchFromBitbucket, pkgconfig, qtbase, qttools, qtmultimedia, zlib, bzip2, xxd }:

stdenv.mkDerivation rec {
  name = "doomseeker-${version}";
  version = "2018-03-05";

  src = fetchFromBitbucket {
    owner = "Doomseeker";
    repo = "doomseeker";
    rev = "c2c7f37b1afb";
    sha256 = "17fna3a604miqsvply3klnmypps4ifz8axgd3pj96z46ybxs8akw";
  };

  patches = [ ./fix_paths.patch ./qt_build_fix.patch ];

  buildInputs = [ qtbase qtmultimedia zlib bzip2 ];

  nativeBuildInputs = [ cmake qttools pkgconfig xxd ];

  enableParallelBuilding = true;

  NIX_CFLAGS_COMPILE = stdenv.lib.optional stdenv.cc.isClang "-Wno-error=format-security";

  meta = with stdenv.lib; {
    homepage = http://doomseeker.drdteam.org/;
    description = "Multiplayer server browser for many Doom source ports";
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = [ maintainers.MP2E ];
  };
}
