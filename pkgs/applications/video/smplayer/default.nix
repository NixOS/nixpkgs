{ stdenv, fetchurl, qmakeHook, qtscript }:

stdenv.mkDerivation rec {
  name = "smplayer-17.3.0";

  src = fetchurl {
    url = "mirror://sourceforge/smplayer/${name}.tar.bz2";
    sha256 = "0yv7725kr3dq02mcanc07sapirx6s73l4b6d13nzvq5rkwr8crmj";
  };

  buildInputs = [ qtscript ];
  nativeBuildInputs = [ qmakeHook ];

  dontUseQmakeConfigure = true;

  preConfigure = ''
    makeFlags="PREFIX=$out"
  '';

  meta = {
    description = "A complete front-end for MPlayer";
    homepage = "http://smplayer.sourceforge.net/";
    license = stdenv.lib.licenses.gpl3Plus;
    platforms = stdenv.lib.platforms.linux;
  };
}
