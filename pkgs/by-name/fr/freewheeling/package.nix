{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  autoreconfHook,
  gnutls,
  freetype,
  fluidsynth,
  SDL,
  SDL_gfx,
  SDL_ttf,
  liblo,
  libxml2,
  alsa-lib,
  libjack2,
  libvorbis,
  libSM,
  libsndfile,
  libogg,
  libtool,
}:
let
  makeSDLFlags = map (p: "-I${lib.getDev p}/include/SDL");
in

stdenv.mkDerivation rec {
  pname = "freewheeling";
  version = "0.6.6";

  src = fetchFromGitHub {
    owner = "free-wheeling";
    repo = "freewheeling";
    rev = "v${version}";
    sha256 = "1xff5whr02cixihgd257dc70hnyf22j3zamvhsvg4lp7zq9l2in4";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
    libtool
  ];
  buildInputs = [
    freetype
    fluidsynth
    SDL
    SDL_gfx
    SDL_ttf
    liblo
    libxml2
    libjack2
    alsa-lib
    libvorbis
    libsndfile
    libogg
    libSM
    (gnutls.overrideAttrs (oldAttrs: {
      configureFlags = oldAttrs.configureFlags ++ [ "--enable-openssl-compatibility" ];
    }))
  ];
  env.NIX_CFLAGS_COMPILE = toString (
    makeSDLFlags [
      SDL
      SDL_ttf
      SDL_gfx
    ]
    ++ [ "-I${libxml2.dev}/include/libxml2" ]
  );

  hardeningDisable = [ "format" ];

  meta = {
    description = "Live looping instrument with JACK and MIDI support";
    longDescription = ''
      Freewheeling allows us to build repetitive grooves
      by sampling and directing loops from within spirited improvisation.

      It works because, down to the core, it's built around
      improv. We leave mice and menus, and dive into our own process
      of making sound.

      Freewheeling runs under macOS and Linux, and is open source
      software, released under the GNU GPL license.
    '';

    homepage = "https://freewheeling.sourceforge.net";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.sepi ];
    platforms = lib.platforms.linux;
    mainProgram = "fweelin";
  };
}
