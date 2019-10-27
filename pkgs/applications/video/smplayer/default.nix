{ lib, mkDerivation, fetchurl, qmake, qtscript }:

mkDerivation rec {
  name = "smplayer-19.5.0";

  src = fetchurl {
    url = "mirror://sourceforge/smplayer/${name}.tar.bz2";
    sha256 = "1xda9pbrc3dfbs71n5l8yszlcywz9456mwkv52vmn8lszhvjpjxm";
  };

  buildInputs = [ qtscript ];
  nativeBuildInputs = [ qmake ];

  dontUseQmakeConfigure = true;

  preConfigure = ''
    makeFlags="PREFIX=$out"
  '';

  meta = {
    description = "A complete front-end for MPlayer";
    homepage = http://smplayer.sourceforge.net/;
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
}
