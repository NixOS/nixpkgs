{ stdenv, fetchurl, qmake, qtscript }:

stdenv.mkDerivation rec {
  name = "smplayer-18.10.0";

  src = fetchurl {
    url = "mirror://sourceforge/smplayer/${name}.tar.bz2";
    sha256 = "1sql1rd4h74smkapjf5c686zbdqqaf44h7k7z5bxfvfcsad7rzrd";
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
    license = stdenv.lib.licenses.gpl3Plus;
    platforms = stdenv.lib.platforms.linux;
  };
}
