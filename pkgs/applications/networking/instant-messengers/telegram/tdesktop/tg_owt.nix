{ lib, stdenv, fetchFromGitHub
, pkg-config, cmake, ninja, yasm
, libjpeg, openssl, libopus, ffmpeg, alsa-lib, libpulseaudio, protobuf
, openh264, usrsctp, libevent, libvpx
, libX11, libXtst, libXcomposite, libXdamage, libXext, libXrender, libXrandr, libXi
, glib, abseil-cpp, pcre, util-linuxMinimal, libselinux, libsepol, pipewire
, mesa, valgrind, libepoxy, libglvnd
}:

stdenv.mkDerivation {
  pname = "tg_owt";
  version = "unstable-2022-04-14";

  src = fetchFromGitHub {
    owner = "desktop-app";
    repo = "tg_owt";
    rev = "63a934db1ed212ebf8aaaa20f0010dd7b0d7b396";
    sha256 = "sha256-WddSsQ9KW1zYyYckzdUOvfFZArYAbyvXmABQNMtK6cM=";
    fetchSubmodules = true;
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ pkg-config cmake ninja yasm ];

  buildInputs = [
    libjpeg openssl libopus ffmpeg alsa-lib libpulseaudio protobuf
    openh264 usrsctp libevent libvpx
    libX11 libXtst libXcomposite libXdamage libXext libXrender libXrandr libXi
    glib abseil-cpp pcre util-linuxMinimal libselinux libsepol pipewire
    mesa libepoxy libglvnd
  ];

  cmakeFlags = [
    # Building as a shared library isn't officially supported and may break at any time.
    "-DBUILD_SHARED_LIBS=OFF"
  ];

  propagatedBuildInputs = [
    # Required for linking downstream binaries.
    abseil-cpp openh264 usrsctp libevent libvpx
  ];

  meta = with lib; {
    license = licenses.bsd3;
    maintainers = with maintainers; [ oxalica ];
  };
}
