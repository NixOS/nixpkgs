{ lib, stdenv, fetchFromGitHub, cmake, perl
, alsa-lib, libevdev, libopus, udev, SDL2
, ffmpeg, pkg-config, xorg, libvdpau, libpulseaudio, libcec
, curl, expat, avahi, libuuid, libva
}:

stdenv.mkDerivation rec {
  pname = "moonlight-embedded";
  version = "2.5.2";

  src = fetchFromGitHub {
    owner = "moonlight-stream";
    repo = "moonlight-embedded";
    rev = "v${version}";
    sha256 = "sha256-YZEPm+k0YzJB8OQAiFUOPc0QR2C0AkSgpNYdoh8jX8E=";
    fetchSubmodules = true;
  };

  outputs = [ "out" "man" ];

  nativeBuildInputs = [ cmake perl pkg-config ];
  buildInputs = [
    alsa-lib libevdev libopus udev SDL2
    ffmpeg xorg.libxcb libvdpau libpulseaudio libcec
    xorg.libpthreadstubs curl expat avahi libuuid libva
  ];

  meta = with lib; {
    description = "Open source implementation of NVIDIA's GameStream";
    homepage = "https://github.com/moonlight-stream/moonlight-embedded";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.globin ];
    platforms = platforms.linux;
  };
}
