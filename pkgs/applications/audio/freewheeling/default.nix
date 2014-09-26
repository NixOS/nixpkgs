{ stdenv, fetchsvn, pkgconfig, autoconf, automake, gnutls, freetype, SDL, SDL_gfx, SDL_ttf, liblo, libxml2, alsaLib, jack2, libvorbis, libsndfile, libogg }:

stdenv.mkDerivation {
  name = "freewheeling-100";

  src = fetchsvn {
    url = svn://svn.code.sf.net/p/freewheeling/code;
    rev = 100;
    sha256 = "1m6z7p93xyha25qma9bazpzbp04pqdv5h3yrv6851775xsyvzksv";
  };

  buildInputs = [ pkgconfig autoconf automake gnutls freetype
                  SDL SDL_gfx SDL_ttf liblo libxml2 jack2 alsaLib
                  libvorbis libsndfile libogg ];

  preConfigure = "autoreconf -vfi";

  patches = [ ./am_path_sdl.patch ./xml.patch ];
  
  meta = {
    description = "A live looping instrument with jack and MIDI support";
    longDescription = "";
    version = "r100";
    homepage = "http://freewheeling.sourceforge.net";
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.sepi ];
    priority = 10;
    platforms = stdenv.lib.platforms.linux;
  };
}
