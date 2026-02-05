{
  lib,
  SDL2,
  autoreconfHook,
  fetchFromGitHub,
  libGLU,
  libX11,
  pkg-config,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "aranym";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "aranym";
    repo = "aranym";
    rev = "ARANYM_${lib.replaceStrings [ "." ] [ "_" ] finalAttrs.version}";
    hash = "sha256-dtcLIA1oC6sPOeGTRmXhMEbuLan9/JWTbQvO5lp3gKo=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    libGLU
    libX11
    SDL2
  ];

  strictDeps = true;

  meta = {
    homepage = "https://aranym.github.io";
    description = "Atari Running on Any Machine";
    longDescription = ''
      ARAnyM is a software virtual machine (similar to VirtualBox or Bochs)
      designed and developed for running 32-bit Atari ST/TT/Falcon operating
      systems (TOS, FreeMiNT, MagiC and Linux-m68k) and TOS/GEM applications on
      any kind of hardware - be it an IBM clone (read it as "PC" :-), an Apple,
      an Unix server, a graphics workstation or even a portable computer.

      ARAnyM is not meant as an emulator of Atari Falcon (even though it has a
      rather high Falcon software compatibility and includes most of Falcon
      custom chips including VIDEL and DSP). ARAnyM is better in the sense that
      it's not tied to specification of an existing Atari machine so we were
      free to select the most complete CPU (68040 with MMU) and FPU (68882), add
      loads of RAM (up to 4 GB), host accelerated graphics (even with OpenGL)
      and direct access to various host resources including sound, disk drives,
      optical storage devices (CD/DVD-ROMs), parallel port and more.
    '';
    license = with lib.licenses; [ gpl2Plus ];
    mainProgram = "aranym";
    maintainers = [ ];
    platforms = lib.platforms.unix;
    # never successfully built on Hydra for darwin or aarch64 linux
    broken = stdenv.hostPlatform.isDarwin || stdenv.hostPlatform.isAarch64;
  };
})
