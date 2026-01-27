{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  perl,
  alsa-lib,
  libevdev,
  libopus,
  udev,
  SDL2,
  ffmpeg,
  pkg-config,
  libpthread-stubs,
  libxcb,
  libvdpau,
  libpulseaudio,
  libcec,
  curl,
  expat,
  avahi,
  libuuid,
  libva,
}:

stdenv.mkDerivation rec {
  pname = "moonlight-embedded";
  version = "2.7.1";

  src = fetchFromGitHub {
    owner = "moonlight-stream";
    repo = "moonlight-embedded";
    tag = "v${version}";
    hash = "sha256-h+hI9TQUGMI8VDzvnuRGDjxm8D7GuC/L4/0rwTFocgA=";
    fetchSubmodules = true;
  };

  outputs = [
    "out"
    "man"
  ];

  nativeBuildInputs = [
    cmake
    perl
    pkg-config
  ];
  buildInputs = [
    alsa-lib
    libevdev
    libopus
    udev
    SDL2
    ffmpeg
    libxcb
    libvdpau
    libpulseaudio
    libcec
    libpthread-stubs
    curl
    expat
    avahi
    libuuid
    libva
  ];

  meta = {
    description = "Open source implementation of NVIDIA's GameStream";
    homepage = "https://github.com/moonlight-stream/moonlight-embedded";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    mainProgram = "moonlight";
    platforms = lib.platforms.linux;
  };
}
