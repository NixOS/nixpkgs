{ stdenv, fetchurl, qt4 }:

stdenv.mkDerivation rec {
  name = "smplayer-0.8.6";

  src = fetchurl {
    url = "mirror://sourceforge/smplayer/${name}.tar.bz2";
    sha256 = "1p70929j8prc4mgqxvsbcjxy8zwp4r9jk0mp0iddxl7vfyck74g0";
  };

  buildInputs = [ qt4 ];

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
