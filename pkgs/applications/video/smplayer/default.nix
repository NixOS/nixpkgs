{ stdenv, fetchurl, qmakeHook, qtscript }:

stdenv.mkDerivation rec {
  name = "smplayer-17.2.0";

  src = fetchurl {
    url = "mirror://sourceforge/smplayer/${name}.tar.bz2";
    sha256 = "05nqwpyh3zlyzip7chs711sz97cgijb92h44cd5aqbwbx06hihdd";
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
