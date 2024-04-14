{ lib
, stdenv
, SDL
, autoreconfHook
, fetchFromGitHub
, libGL
, libGLU
, libX11
, readline
, zlib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "atari800";
  version = "5.2.0";

  src = fetchFromGitHub {
    owner = "atari800";
    repo = "atari800";
    rev = "ATARI800_${lib.replaceStrings ["."] ["_"] finalAttrs.version}";
    hash = "sha256-D66YRRTqdoV9TqDFonJ9XNpfP52AicuYgdiW27RCIuQ=";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  buildInputs = [
    SDL
    libGL
    libGLU
    libX11
    readline
    zlib
  ];

  configureFlags = [
    "--target=default"
    (lib.enableFeature true "riodevice")
    (lib.withFeature true "opengl")
    (lib.withFeature true "readline")
    (lib.withFeature true "x")
    (lib.withFeatureAs true "sound" "sdl")
    (lib.withFeatureAs true "video" "sdl")
  ];

  meta = {
    homepage = "https://atari800.github.io/";
    description = "An Atari 8-bit emulator";
    longDescription = ''
      Atari800 is the emulator of Atari 8-bit computer systems and 5200 game
      console for Unix, Linux, Amiga, MS-DOS, Atari TT/Falcon, MS-Windows, MS
      WinCE, Sega Dreamcast, Android and other systems supported by the SDL
      library.
    '';
    license = with lib.licenses; [ gpl2Plus ];
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.linux;
  };
})
