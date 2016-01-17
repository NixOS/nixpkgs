{ stdenv, fetchsvn, pkgconfig, autoreconfHook, gnutls33, freetype
, SDL, SDL_gfx, SDL_ttf, liblo, libxml2, alsaLib, libjack2, libvorbis
, libsndfile, libogg
}:

stdenv.mkDerivation {
  name = "freewheeling-100";

  src = fetchsvn {
    url = svn://svn.code.sf.net/p/freewheeling/code;
    rev = 100;
    sha256 = "1m6z7p93xyha25qma9bazpzbp04pqdv5h3yrv6851775xsyvzksv";
  };

  buildInputs = [
    pkgconfig autoreconfHook gnutls33 freetype SDL SDL_gfx SDL_ttf
    liblo libxml2 libjack2 alsaLib libvorbis libsndfile libogg
  ];

  patches = [ ./am_path_sdl.patch ./xml.patch ];

  meta = {
    description = "A live looping instrument with JACK and MIDI support";
    longDescription = ''
        Freewheeling allows us to build repetitive grooves
        by sampling and directing loops from within spirited improvisation.

        It works because, down to the core, it's built around
        improv. We leave mice and menus, and dive into our own process
        of making sound.

        Freewheeling runs under Mac OS X and Linux, and is open source
        software, released under the GNU GPL license.
    '' ;

    version = "r100";
    homepage = "http://freewheeling.sourceforge.net";
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.sepi ];
    platforms = stdenv.lib.platforms.linux;
  };
}
