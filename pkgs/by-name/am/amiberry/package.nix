{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  curl,
  enet,
  flac,
  libGL,
  libmpeg2,
  libmpg123,
  libpcap,
  libpng,
  libserialport,
  nlohmann_json,
  portmidi,
  sdl3,
  sdl3-image,
  zstd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "amiberry";
  version = "8.1.5";

  src = fetchFromGitHub {
    owner = "BlitterStudio";
    repo = "amiberry";
    tag = "v${finalAttrs.version}";
    hash = "sha256-udSMQxpELpk3Shu3+weHA9S0i/WMdVnrOuLGZ0whEEI=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    curl
    enet
    flac
    libGL
    libmpeg2
    libmpg123
    libpcap
    libpng
    libserialport
    nlohmann_json
    portmidi
    sdl3
    sdl3-image
    zstd
  ];

  enableParallelBuilding = true;

  meta = {
    homepage = "https://github.com/BlitterStudio/amiberry";
    description = "Optimized Amiga emulator for Linux/macOS";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = [ ];
    mainProgram = "amiberry";
  };
})
