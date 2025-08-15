{
  lib,
  SDL2,
  SDL2_image,
  SDL2_mixer,
  cmake,
  fetchFromGitHub,
  pkg-config,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "doomretro";
  version = "5.7.2";

  src = fetchFromGitHub {
    owner = "bradharding";
    repo = "doomretro";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ShzZMmUwPB8IHhaA/7U4CEE7qcEjxfQDXVZkAVuEgtw=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    SDL2
    SDL2_image
    SDL2_mixer
  ];

  strictDeps = true;

  meta = {
    homepage = "https://www.doomretro.com/";
    description = "Classic, refined DOOM source port";
    longDescription = ''
      DOOM Retro is the classic, refined DOOM source port for Windows PC. It
      represents how I like my DOOM to be today, in all its dark and gritty,
      unapologetically pixelated glory. I have strived to craft a unique and
      cohesive set of compelling features, while continuing to uphold my respect
      for that classic, nostalgic DOOM experience many of us, after all this
      time, still hold dear.

      DOOM Retro has been under relentless, meticulous development since its
      debut on December 10, 2013 commemorating DOOM's 20th anniversary, and it
      has absolutely no intention of stopping. Its source code was originally
      derived from Chocolate DOOM but is now very much its own beast. It does
      include the usual, necessary enhancements that you'll find in all those
      other DOOM source ports out there, but it also has many of its own cool,
      original ideas that continues to set itself apart.

      DOOM Retro is and always will be intentionally minimalistic in its
      approach, and does a few things differently. It supports all vanilla,
      limit removing, BOOM, MBF and MBF21-compatible maps and mods. In order to
      freely implement certain features, and due to the nature of DOOM demos,
      DOOM Retro does not support their recording or playback.

      DOOM Retro is singleplayer only. Written in C, and released as free, open
      source software under version 3 of the GNU General Public License, DOOM
      Retro's 100,000 or so lines of code are diligently maintained in this
      public Git repository and regularly compiled into both 32 and 64-bit
      Windows apps using Microsoft Visual Studio Community 2022. Although next
      to no support is provided, DOOM Retro's source code may also be compiled
      and run under Linux and macOS.
    '';
    license = lib.licenses.gpl3Plus;
    mainProgram = "doomretro";
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.unix;
  };
})
