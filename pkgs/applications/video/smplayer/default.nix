{ stdenv, fetchurl, qmakeHook, qtscript }:

stdenv.mkDerivation rec {
  name = "smplayer-17.1.0";

  src = fetchurl {
    url = "mirror://sourceforge/smplayer/${name}.tar.bz2";
    sha256 = "0wgw940gxf3gqh6xzxvz037ipvr1xcw86gf0myvpb4lkwqh5jds0";
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
