{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, cmake
, ninja
, yasm
, libjpeg
, openssl
, libopus
, ffmpeg_4
, protobuf
, openh264
, usrsctp
, libvpx
, libX11
, libXtst
, libXcomposite
, libXdamage
, libXext
, libXrender
, libXrandr
, libXi
, glib
, abseil-cpp
, pipewire
, mesa
, libglvnd
, libepoxy
}:

stdenv.mkDerivation {
  pname = "tg_owt";
  version = "unstable-2022-02-26";

  src = fetchFromGitHub {
    owner = "desktop-app";
    repo = "tg_owt";
    rev = "a264028ec71d9096e0aa629113c49c25db89d260";
    sha256 = "sha256-JR+M+4w0QsQLfIunZ/7W+5Knn+gX+RR3DBrpOz7q44I=";
    fetchSubmodules = true;
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ pkg-config cmake ninja yasm ];

  buildInputs = [
    libjpeg
    openssl
    libopus
    ffmpeg_4
    protobuf
    openh264
    usrsctp
    libvpx
    libX11
    libXtst
    libXcomposite
    libXdamage
    libXext
    libXrender
    libXrandr
    libXi
    glib
    abseil-cpp
    pipewire
    mesa
    libepoxy
    libglvnd
  ];

  enableParallelBuilding = true;

  propagatedBuildInputs = [
    # Required for linking downstream binaries.
    abseil-cpp
    openh264
    usrsctp
    libvpx
  ];

  meta.license = lib.licenses.bsd3;
}
