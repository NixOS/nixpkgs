{ stdenv, fetchurl, qmake, qtscript }:

stdenv.mkDerivation rec {
  name = "smplayer-18.4.0";

  src = fetchurl {
    url = "mirror://sourceforge/smplayer/${name}.tar.bz2";
    sha256 = "0q2fbg41djyxsy6jinlnidpcqxvs9bi91ga3fwlgnfh6kxsw2ldd";
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
