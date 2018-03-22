{ stdenv, fetchurl, qmake, qtscript }:

stdenv.mkDerivation rec {
  name = "smplayer-18.2.2";

  src = fetchurl {
    url = "mirror://sourceforge/smplayer/${name}.tar.bz2";
    sha256 = "0q0m9q643z6ih5gkf1fq3d6y99d62yxkhfgap98h251q6kd7dhis";
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
