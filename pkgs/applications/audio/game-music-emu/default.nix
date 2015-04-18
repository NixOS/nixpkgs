{ stdenv, fetchurl, cmake }:

stdenv.mkDerivation rec {
  version = "0.6.0";
  name = "game-music-emu-${version}";

  src = fetchurl {
    url = "https://game-music-emu.googlecode.com/files/${name}.tar.bz2";
    sha256 = "11s9l938nxbrk7qb2k1ppfgizcz00cakbxgv0gajc6hyqv882vjh";
  };

  buildInputs = [ cmake ];

  meta = with stdenv.lib; {
    homepage = https://code.google.com/p/game-music-emu/;
    description = "A collection of video game music file emulators";
    license = licenses.lgpl21Plus;
    platforms = platforms.all;
    maintainers = [ ];
  };
}
