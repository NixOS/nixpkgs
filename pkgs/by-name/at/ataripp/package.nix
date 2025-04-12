{
  lib,
  stdenv,
  SDL,
  alsa-lib,
  fetchurl,
  gcc-unwrapped,
  libICE,
  libSM,
  libX11,
  libXext,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "atari++";
  version = "1.85";

  src = fetchurl {
    url = "http://www.xl-project.com/download/atari++_${finalAttrs.version}.tar.gz";
    hash = "sha256-LbGTVUs1XXR+QfDhCxX9UMkQ3bnk4z0ckl94Cwwe9IQ=";
  };

  buildInputs = [
    SDL
    alsa-lib
    gcc-unwrapped
    libICE
    libSM
    libX11
    libXext
  ];

  postFixup = ''
    patchelf \
      --set-rpath ${lib.makeLibraryPath finalAttrs.buildInputs} \
      "$out/bin/atari++"
  '';

  meta = {
    homepage = "http://www.xl-project.com/";
    description = "Enhanced, cycle-accurated Atari emulator";
    mainProgram = "atari++";
    longDescription = ''
      The Atari++ Emulator is a Unix based emulator of the Atari eight bit
      computers, namely the Atari 400 and 800, the Atari 400XL, 800XL and 130XE,
      and the Atari 5200 game console. The emulator is auto-configurable and
      will compile on a variety of systems (Linux, Solaris, Irix).
    '';
    maintainers = with lib.maintainers; [ AndersonTorres ];
    license = with lib.licenses; [ gpl2Plus ];
    platforms = lib.platforms.unix;
  };
})
