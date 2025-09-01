{
  lib,
  stdenv,
  fetchurl,
  libarchive,
  SDL,
}:

stdenv.mkDerivation rec {
  pname = "dgen-sdl";
  version = "1.33";

  src = fetchurl {
    url = "https://sourceforge.net/projects/dgen/files/dgen/${version}/${pname}-${version}.tar.gz";
    hash = "sha256-meLAYBfCKHPHf4gYbrzAmGckTrbgQsdjuwlLArje9h4=";
  };

  buildInputs = [
    SDL
    libarchive
  ];

  configureFlags = [
    (lib.enableFeature (!stdenv.hostPlatform.isDarwin) "sdltest")
    "--enable-debug-vdp"
    "--enable-debugger"
    "--enable-joystick"
    "--enable-pico" # experimental
    "--enable-vgmdump"
    "--with-cyclone=no" # Needs ASM support
    "--with-cz80"
    "--with-drz80=no" # Needs ASM support
    "--with-dz80"
    "--with-musa"
    "--with-mz80"
    "--with-star=no" # Needs ASM support
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-Wno-reserved-user-defined-literal";

  meta = with lib; {
    homepage = "https://dgen.sourceforge.net/";
    description = "Sega Genesis/Mega Drive emulator";
    longDescription = ''
      DGen/SDL is a free, open source emulator for Sega Genesis/Mega Drive
      systems. DGen was originally written by Dave, then ported to SDL by Joe
      Groff and Phil K. Hornung in 1998.

      It features:

      - Game Genie/Hex codes support
      - PAL/NTSC, fullscreen modes
      - Joypad/joystick support
      - Mouse support
      - Highly configurable controls
      - OpenGL textured video output
      - Portable (64‐bit, endian safe), runs in Windows using MinGW
      - Screenshots, demos recording and playback
      - Musashi (generic) and StarScream (x86‐only) CPU cores
      - Cyclone 68000 and DrZ80 (both ARM‐only) CPU cores
      - CZ80 (generic) and MZ80 (generic and x86‐only versions)
      - 16‐bit, 8000 to 48000Hz sound output
      - Support for 8, 15, 16, 24 and 32 bpp modes
      - Archived/compressed ROMs support
      - M68K debugger (contributed by Edd Barrett)
      - Z80 debugger
      - hqx and scale2x upscaling filters
      - VGM dumping
    '';
    license = licenses.mit;
    maintainers = [ ];
    platforms = with platforms; unix;
  };
}
# TODO: implement configure options
