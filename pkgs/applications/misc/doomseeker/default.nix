{ stdenv, cmake, fetchFromBitbucket, pkgconfig, qtbase, qttools, qtmultimedia, zlib, bzip2 }:

stdenv.mkDerivation rec {
  name = "doomseeker-${version}";
  version = "2018-03-03";

  src = fetchFromBitbucket {
    owner = "Doomseeker";
    repo = "doomseeker";
    rev = "072110a8fe0643c4a72461e7768560813bb0a62b";
    sha256 = "1w4g5f7yifqk2d054dqrmy8qj4n5hxdan7n59845m1xh2f2r8i0p";
  };

  patches = [ ./fix_paths.patch ];

  buildInputs = [ qtbase qtmultimedia zlib bzip2 ];

  nativeBuildInputs = [ cmake qttools pkgconfig ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://doomseeker.drdteam.org/;
    description = "Multiplayer server browser for many Doom source ports";
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = [ maintainers.MP2E ];
  };
}
