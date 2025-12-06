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
  xorg,
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
    xorg.libxcb
    libvdpau
    libpulseaudio
    libcec
    xorg.libpthreadstubs
    curl
    expat
    avahi
    libuuid
    libva
  ];

  meta = with lib; {
    description = "Open source implementation of NVIDIA's GameStream";
    homepage = "https://github.com/moonlight-stream/moonlight-embedded";
    license = licenses.gpl3Plus;
    maintainers = [ ];
    mainProgram = "moonlight";
    platforms = platforms.linux;
  };
}
