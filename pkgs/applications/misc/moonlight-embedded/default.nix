{ stdenv, fetchFromGitHub, cmake, perl
, alsaLib, libevdev, libopus, libudev, SDL2
, ffmpeg, pkgconfig, xorg, libvdpau, libpulseaudio, libcec
, curl, expat, avahi, enet, libuuid
}:

stdenv.mkDerivation rec {
  name = "moonlight-embedded-${version}";
  version = "2.2.3";

  # fetchgit used to ensure submodules are available
  src = fetchFromGitHub {
    owner = "irtimmer";
    repo = "moonlight-embedded";
    rev = "refs/tags/v${version}";
    sha256 = "1ydb1hfkakzpz7cg9giwc00pjzp6w3bn4jvcp5fajchghiy2c58y";
  };

  outputs = [ "out" "doc" ];

  nativeBuildInputs = [ cmake perl ];
  buildInputs = [
    alsaLib libevdev libopus libudev SDL2
    ffmpeg pkgconfig xorg.libxcb libvdpau libpulseaudio libcec
    xorg.libpthreadstubs curl expat avahi enet libuuid
  ];

  meta = with stdenv.lib; {
    description = "Open source implementation of NVIDIA's GameStream";
    homepage = https://github.com/irtimmer/moonlight-embedded;
    license = licenses.gpl3;
    maintainers = [ maintainers.globin ];
    platforms = platforms.linux;
  };
}
