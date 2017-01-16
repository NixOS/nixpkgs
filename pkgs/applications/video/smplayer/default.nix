{ stdenv, fetchurl, qmakeHook, qtscript }:

stdenv.mkDerivation rec {
  name = "smplayer-16.11.0";

  src = fetchurl {
    url = "mirror://sourceforge/smplayer/${name}.tar.bz2";
    sha256 = "0nhbr33p21qb7n6wry0nkavl5nfjzl5yylrhnxz0pyv69n5msfp5";
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
