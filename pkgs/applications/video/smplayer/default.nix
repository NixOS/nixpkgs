{ stdenv, fetchurl, qmakeHook, qtscript, mplayer, makeWrapper }:

stdenv.mkDerivation rec {
  name = "smplayer-16.1.0";

  src = fetchurl {
    url = "mirror://sourceforge/smplayer/${name}.tar.bz2";
    sha256 = "1jfqpmbbjrs9lna44dp10zblj7b0cras9sb0nczycpkcsdi9np6j";
  };

  patches = [ ./basegui.cpp.patch ];

  buildInputs = [ qmakeHook qtscript makeWrapper ];

  dontUseQmakeConfigure = true;

  preConfigure = ''
    makeFlags="PREFIX=$out"
  '';

  postInstall = ''
    wrapProgram $out/bin/smplayer --suffix PATH : ${mplayer}/bin
  '';

  meta = {
    description = "A complete front-end for MPlayer";
    homepage = "http://smplayer.sourceforge.net/";
    license = stdenv.lib.licenses.gpl3Plus;
    platforms = stdenv.lib.platforms.linux;
  };
}
