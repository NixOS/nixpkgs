{ stdenv
, lib
, fetchFromGitHub
, zlib
, pkg-config
, libuv
, curl
, ffmpeg
, glfw
, capstone
, freetype
, libX11
, imagemagick
, libpulseaudio
, alsa-lib
}:

stdenv.mkDerivation rec {
  pname = "pcsx-redux";
  version = "unstable-2023-04-18";

  src = fetchFromGitHub {
    owner = "grumpycoders";
    repo = "pcsx-redux";
    fetchSubmodules = true;
    rev = "0093bea292920f1d1c3eb7515026b4153fe2e926";
    hash = "sha256-Mwg4jAve0nLuODV/8JO4t5akswi3/qRU/Q5UihJnbps=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    imagemagick
    libX11
    freetype
    capstone
    glfw
    ffmpeg
    curl
    libuv
    zlib
  ];

  # A dependency in third_party (miniaudio) tries to load audio backends on
  # demand, by querying dynamic libraries at runtime. Patch the paths to point
  # at ALSA and PulseAudio backends so that it has a chance of finding them, say
  # on NixOS. There are more backends, such as OSS and JACK. I guess we can add
  # these on demand in the future.
  postPatch = lib.optionalString stdenv.isLinux ''
    substituteInPlace third_party/miniaudio/miniaudio.h \
      --replace 'libasound.so' '${alsa-lib}/lib/libasound.so'
    substituteInPlace third_party/miniaudio/extras/miniaudio_split/miniaudio.c \
      --replace 'libasound.so' '${alsa-lib}/lib/libasound.so'
    substituteInPlace third_party/miniaudio/miniaudio.h \
      --replace 'libpulse.so' '${libpulseaudio}/lib/libpulse.so'
    substituteInPlace third_party/miniaudio/extras/miniaudio_split/miniaudio.c \
      --replace 'libpulse.so' '${libpulseaudio}/lib/libpulse.so'
  '';

  # Fails with -Wformat-security: https://github.com/grumpycoders/pcsx-redux/issues/1250
  hardeningDisable = [ "format" ];

  # DESTDIR defauts to /usr/local. Yeah, I know that we're not supposed to set
  # this (https://github.com/NixOS/nixpkgs/issues/65718) but I think we have to
  # because this repo doesn't use configure (so no --prefix) nor does it leave
  # DESTDIR unset.
  makeFlags = [ "DESTDIR=$(out)" ];

  meta = with lib; {
    description = "This is yet another fork of the Playstation emulator, PCSX";
    maintainers = with maintainers; [ fuuzetsu ];

    license = licenses.gpl2Only;
    platforms = platforms.x86_64;
  };
}
