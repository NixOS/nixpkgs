{
  lib,
  stdenv,
  SDL2,
  autoreconfHook,
  fetchFromGitHub,
  libGL,
  libGLU,
  libx11,
  readline,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "atari800";
  version = "7.2.1";

  src = fetchFromGitHub {
    owner = "atari800";
    repo = "atari800";
    rev = "ATARI800_${lib.replaceStrings [ "." ] [ "_" ] finalAttrs.version}";
    hash = "sha256-cDiEFPE9JPonLdlBcKWZ1FGDMAQwuVihYtshcd8bcyM=";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  buildInputs = [
    SDL2
    libGL
    libGLU
    libx11
    readline
    zlib
  ];

  configureFlags = [
    "--target=default"
    (lib.enableFeature true "riodevice")
    (lib.withFeature true "opengl")
    (lib.withFeature true "readline")
    (lib.withFeature true "x")
    (lib.withFeatureAs true "sound" "sdl2")
    (lib.withFeatureAs true "video" "sdl2")
  ];

  meta = {
    homepage = "https://atari800.github.io/";
    changelog = "https://github.com/atari800/atari800/releases/tag/${finalAttrs.src.rev}";
    description = "Atari 8-bit emulator";
    longDescription = ''
      Atari800 is the emulator of Atari 8-bit computer systems and 5200 game
      console for Unix, Linux, Amiga, MS-DOS, Atari TT/Falcon, MS-Windows, MS
      WinCE, Sega Dreamcast, Android and other systems supported by the SDL
      library.
    '';
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
