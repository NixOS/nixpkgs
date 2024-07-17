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
  version = "2.7.0";

  src = fetchFromGitHub {
    owner = "moonlight-stream";
    repo = "moonlight-embedded";
    rev = "v${version}";
    sha256 = "sha256-Jc706BjIT3rS9zwntNOdgszP4CHuX+qxvPvWeU68Amg=";
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
