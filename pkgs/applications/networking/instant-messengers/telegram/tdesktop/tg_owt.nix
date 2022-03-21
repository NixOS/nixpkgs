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
  version = "unstable-2022-02-25";

  src = fetchFromGitHub {
    owner = "desktop-app";
    repo = "tg_owt";
    rev = "a264028ec71d9096e0aa629113c49c25db89d260";
    sha256 = "10p3x8z3ps8s1ivi9y8px2gsg4pvsvz6g9wbgh5w8hilikxqq7r5";
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
