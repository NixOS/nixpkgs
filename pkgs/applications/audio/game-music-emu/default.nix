{ lib, stdenv, fetchurl, cmake }:

stdenv.mkDerivation rec {
  version = "0.6.3";
  pname = "game-music-emu";

  src = fetchurl {
    url = "https://bitbucket.org/mpyne/game-music-emu/downloads/${pname}-${version}.tar.xz";
    sha256 = "07857vdkak306d9s5g6fhmjyxk7vijzjhkmqb15s7ihfxx9lx8xb";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    homepage = "https://bitbucket.org/mpyne/game-music-emu/wiki/Home";
    description = "A collection of video game music file emulators";
    license = licenses.lgpl21Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ luc65r ];
  };
}
