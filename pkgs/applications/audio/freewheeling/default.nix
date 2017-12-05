{ stdenv, fetchFromGitHub, pkgconfig, autoreconfHook, gnutls, freetype
, SDL, SDL_gfx, SDL_ttf, liblo, libxml2, alsaLib, libjack2, libvorbis
, libSM, libsndfile, libogg
}:

stdenv.mkDerivation rec {
  name = "freewheeling-${version}";
  version = "2016-11-15";

  src = fetchFromGitHub {
    owner = "free-wheeling";
    repo = "freewheeling";
    rev = "05ef3bf150fa6ba1b1d437b1fd70ef363289742f";
    sha256 = "19plf7r0sq4271ln5bya95mp4i1j30x8hsxxga2kla27z953n9ih";
  };

  nativeBuildInputs = [ pkgconfig autoreconfHook ];
  buildInputs = [
    freetype SDL SDL_gfx SDL_ttf
    liblo libxml2 libjack2 alsaLib libvorbis libsndfile libogg libSM
    (gnutls.overrideAttrs (oldAttrs: {
      configureFlags = oldAttrs.configureFlags ++ [ "--enable-openssl-compatibility" ];
    }))
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

        Freewheeling runs under macOS and Linux, and is open source
        software, released under the GNU GPL license.
    '' ;

    homepage = http://freewheeling.sourceforge.net;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.sepi ];
    platforms = stdenv.lib.platforms.linux;
  };
}
