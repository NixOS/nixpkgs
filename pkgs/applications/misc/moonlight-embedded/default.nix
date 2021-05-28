{ stdenv, fetchFromGitHub, cmake, perl
, alsaLib, libevdev, libopus, udev, SDL2
, ffmpeg_3, pkgconfig, xorg, libvdpau, libpulseaudio, libcec
, curl, expat, avahi, enet, libuuid, libva
}:

stdenv.mkDerivation rec {
  pname = "moonlight-embedded";
  version = "2.4.10";

  src = fetchFromGitHub {
    owner = "irtimmer";
    repo = "moonlight-embedded";
    rev = "v${version}";
    sha256 = "0m5i3q3hbjl51cndjpz5hxi3br6fvpn1fzdv0f6lxjxgw9z32413";
    fetchSubmodules = true;
  };

  outputs = [ "out" "man" ];

  nativeBuildInputs = [ cmake perl ];
  buildInputs = [
    alsaLib libevdev libopus udev SDL2
    ffmpeg_3 pkgconfig xorg.libxcb libvdpau libpulseaudio libcec
    xorg.libpthreadstubs curl expat avahi enet libuuid libva
  ];

  meta = with stdenv.lib; {
    description = "Open source implementation of NVIDIA's GameStream";
    homepage = "https://github.com/irtimmer/moonlight-embedded";
    license = licenses.gpl3;
    maintainers = [ maintainers.globin ];
    platforms = platforms.linux;
  };
}
