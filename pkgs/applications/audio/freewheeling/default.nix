{ stdenv, fetchsvn, pkgconfig, autoreconfHook, gnutls33, freetype
, SDL, SDL_gfx, SDL_ttf, liblo, libxml2, alsaLib, libjack2, libvorbis
, libSM, libsndfile, libogg
}:

stdenv.mkDerivation rec {
  name = "freewheeling-${version}";
  version = "100";

  src = fetchsvn {
    url = svn://svn.code.sf.net/p/freewheeling/code;
    rev = version;
    sha256 = "1m6z7p93xyha25qma9bazpzbp04pqdv5h3yrv6851775xsyvzksv";
  };

  nativeBuildInputs = [ pkgconfig autoreconfHook ];
  buildInputs = [
    gnutls33 freetype SDL SDL_gfx SDL_ttf
    liblo libxml2 libjack2 alsaLib libvorbis libsndfile libogg libSM
  ];

  patches = [ ./am_path_sdl.patch ./xml.patch ];

  hardeningDisable = [ "format" ];

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

    homepage = "http://freewheeling.sourceforge.net";
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.sepi ];
    platforms = stdenv.lib.platforms.linux;
  };
}
