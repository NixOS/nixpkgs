{ lib, stdenv, fetchFromGitHub, cmake, perl
, alsa-lib, libevdev, libopus, udev, SDL2
, ffmpeg, pkg-config, xorg, libvdpau, libpulseaudio, libcec
, curl, expat, avahi, enet, libuuid, libva
}:

stdenv.mkDerivation rec {
  pname = "moonlight-embedded";
  version = "2.4.11";

  src = fetchFromGitHub {
    owner = "irtimmer";
    repo = "moonlight-embedded";
    rev = "v${version}";
    sha256 = "19wm4gizj8q6j4jwqfcn3bkhms97d8afwxmqjmjnqqxzpd2gxc16";
    fetchSubmodules = true;
  };

  outputs = [ "out" "man" ];

  nativeBuildInputs = [ cmake perl ];
  buildInputs = [
    alsa-lib libevdev libopus udev SDL2
    ffmpeg pkg-config xorg.libxcb libvdpau libpulseaudio libcec
    xorg.libpthreadstubs curl expat avahi enet libuuid libva
  ];

  meta = with lib; {
    description = "Open source implementation of NVIDIA's GameStream";
    homepage = "https://github.com/irtimmer/moonlight-embedded";
    license = licenses.gpl3;
    maintainers = [ maintainers.globin ];
    platforms = platforms.linux;
  };
}
