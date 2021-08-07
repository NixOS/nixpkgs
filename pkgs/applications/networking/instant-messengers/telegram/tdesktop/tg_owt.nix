{ lib, stdenv, fetchFromGitHub
, pkg-config, cmake, ninja, yasm
, libjpeg, openssl, libopus, ffmpeg, alsa-lib, libpulseaudio, protobuf
, openh264, usrsctp, libevent, libvpx
, libX11, libXtst, libXcomposite, libXdamage, libXext, libXrender, libXrandr, libXi
, glib, abseil-cpp, pcre, util-linuxMinimal, libselinux, libsepol, pipewire
}:

stdenv.mkDerivation {
  pname = "tg_owt";
  version = "unstable-2021-06-27";

  src = fetchFromGitHub {
    owner = "desktop-app";
    repo = "tg_owt";
    rev = "91d836dc84a16584c6ac52b36c04c0de504d9c34";
    sha256 = "1ir4svv5mijpzr0rmx65088iikck83vhcdqrpf9dnk6yp4j9v4v2";
    fetchSubmodules = true;
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ pkg-config cmake ninja yasm ];

  buildInputs = [
    libjpeg openssl libopus ffmpeg alsa-lib libpulseaudio protobuf
    openh264 usrsctp libevent libvpx
    libX11 libXtst libXcomposite libXdamage libXext libXrender libXrandr libXi
    glib abseil-cpp pcre util-linuxMinimal libselinux libsepol pipewire
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
