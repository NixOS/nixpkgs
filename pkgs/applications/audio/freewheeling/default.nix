{ lib, stdenv, fetchFromGitHub, pkgconfig, autoreconfHook, gnutls, freetype
, SDL, SDL_gfx, SDL_ttf, liblo, libxml2, alsaLib, libjack2, libvorbis
, libSM, libsndfile, libogg, libtool
}:
let
  makeSDLFlags = map (p: "-I${lib.getDev p}/include/SDL");
in

stdenv.mkDerivation rec {
  pname = "freewheeling";
  version = "0.6.5";

  src = fetchFromGitHub {
    owner = "free-wheeling";
    repo = "freewheeling";
    rev = "v${version}";
    sha256 = "1gjii2kndffj9iqici4vb9zrkrdqj1hs9q43x7jv48wv9872z78r";
  };

  nativeBuildInputs = [ pkgconfig autoreconfHook libtool ];
  buildInputs = [
    freetype SDL SDL_gfx SDL_ttf
    liblo libxml2 libjack2 alsaLib libvorbis libsndfile libogg libSM
    (gnutls.overrideAttrs (oldAttrs: {
      configureFlags = oldAttrs.configureFlags ++ [ "--enable-openssl-compatibility" ];
    }))
  ];
  NIX_CFLAGS_COMPILE = toString
    (makeSDLFlags [ SDL SDL_ttf SDL_gfx ] ++ [ "-I${libxml2.dev}/include/libxml2" ]);

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
