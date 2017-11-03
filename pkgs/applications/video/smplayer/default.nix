{ stdenv, fetchurl, qmake, qtscript }:

stdenv.mkDerivation rec {
  name = "smplayer-17.9.0";

  src = fetchurl {
    url = "mirror://sourceforge/smplayer/${name}.tar.bz2";
    sha256 = "0s9856cmwl829d2xc2ycf97phpv4a2d39ybmnbhsrb07jq5hkw1a";
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
