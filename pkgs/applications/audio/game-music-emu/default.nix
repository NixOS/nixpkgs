{ stdenv, fetchurl, cmake }:

stdenv.mkDerivation rec {
  version = "0.6.1";
  pname = "game-music-emu";

  src = fetchurl {
    url = "https://bitbucket.org/mpyne/game-music-emu/downloads/${pname}-${version}.tar.bz2";
    sha256 = "08fk7zddpn7v93d0fa7fcypx7hvgwx9b5psj9l6m8b87k2hbw4fw";
  };

  buildInputs = [ cmake ];

  meta = with stdenv.lib; {
    homepage = "https://bitbucket.org/mpyne/game-music-emu/wiki/Home";
    description = "A collection of video game music file emulators";
    license = licenses.lgpl21Plus;
    platforms = platforms.all;
    maintainers = [ ];
  };
}
