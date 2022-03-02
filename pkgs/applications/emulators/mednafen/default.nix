{ lib
, stdenv
, fetchurl
, SDL2
, SDL2_net
, alsa-lib
, flac
, freeglut
, libGL
, libGLU
, libX11
, libcdio
, libjack2
, libsamplerate
, libsndfile
, pkg-config
, zlib
, libiconv
}:

stdenv.mkDerivation rec {
  pname = "mednafen";
  version = "1.29.0";

  src = fetchurl {
    url = "https://mednafen.github.io/releases/files/${pname}-${version}.tar.xz";
    hash = "sha256-2j+88Ch3+b4PAov6XRy1npU6QEm5D+fjk4ijOG2fNi4=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    SDL2
    SDL2_net
    flac
    freeglut
    libcdio
    libjack2
    libsamplerate
    libsndfile
    zlib
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    libGL
    libGLU
    libX11
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  hardeningDisable = [ "pic" "format" ];

  enableParallelBuilding = true;

  postInstall = ''
    mkdir -p $out/share/doc
    mv Documentation $out/share/doc/mednafen
  '';

  meta = with lib; {
    homepage = "https://mednafen.github.io/";
    description = "A portable, CLI-driven, SDL+OpenGL-based, multi-system emulator";
    longDescription = ''
      Mednafen is a portable, utilizing OpenGL and SDL,
      argument(command-line)-driven multi-system emulator. Mednafen has the
      ability to remap hotkey functions and virtual system inputs to a keyboard,
      a joystick, or both simultaneously. Save states are supported, as is
      real-time game rewinding. Screen snapshots may be taken, in the PNG file
      format, at the press of a button. Mednafen can record audiovisual movies
      in the QuickTime file format, with several different lossless codecs
      supported.

      The following systems are supported (refer to the emulation module
      documentation for more details):

      - Apple II/II+
      - Atari Lynx
      - Neo Geo Pocket (Color)
      - WonderSwan
      - GameBoy (Color)
      - GameBoy Advance
      - Nintendo Entertainment System
      - Super Nintendo Entertainment System/Super Famicom
      - Virtual Boy
      - PC Engine/TurboGrafx 16 (CD)
      - SuperGrafx
      - PC-FX
      - Sega Game Gear
      - Sega Genesis/Megadrive
      - Sega Master System
      - Sega Saturn (experimental, x86_64 only)
      - Sony PlayStation
    '';
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.unix;
  };
}
