{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  nasm,
  alsa-lib,
  ffmpeg_7,
  glew,
  glib,
  gtk3,
  libmad,
  libogg,
  libpng,
  libpulseaudio,
  libvorbis,
  udev,
  xorg,
  zlib,
}:

stdenv.mkDerivation {
  pname = "stepmania";
  version = "5.1.0-b2-unstable-2022-11-14";

  src = fetchFromGitHub {
    owner = "stepmania";
    repo = "stepmania";
    rev = "d55acb1ba26f1c5b5e3048d6d6c0bd116625216f";
    hash = "sha256-49H2Q61R4l/G0fWsjCjiAUXeWwG3lcsDpV5XvR3l3QE=";
  };

  patches = [
    (fetchpatch {
      # Fix building with newer FFmpeg
      name = "fix-building-with-newer-ffmpeg.patch";
      url = "https://github.com/stepmania/stepmania/commit/3fef5ef60b7674d6431f4e1e4ba8c69b0c21c023.patch?full_index=1";
      hash = "sha256-m+5sP+mIpcSjioRBdzChqja5zwNcwdSNAfvSJ2Lww+g=";
    })
    (fetchpatch {
      # Fix crash on loading animated previews while using newer FFmpeg
      name = "fix-crash-newer-ffmpeg.patch";
      url = "https://github.com/stepmania/stepmania/commit/e0d2a5182dcd855e181fffa086273460c553c7ff.patch?full_index=1";
      hash = "sha256-XacaMn29FwG3WgFBfB890I8mzVrvuOL4wPWcHHNYfXM=";
    })
    # FFmpeg 7 frame_number compatibility fix
    ./ffmpeg-7.patch
  ];

  postPatch = ''
    sed '1i#include <ctime>' -i src/arch/ArchHooks/ArchHooks.h # gcc12

    substituteInPlace CMakeLists.txt \
      --replace-fail 'cmake_minimum_required(VERSION 2.8.12)' 'cmake_minimum_required(VERSION 3.10)'
  '';

  nativeBuildInputs = [
    cmake
    nasm
  ];

  buildInputs = [
    alsa-lib
    ffmpeg_7
    glew
    glib
    gtk3
    libmad
    libogg
    libpng
    libpulseaudio
    libvorbis
    udev
    xorg.libXtst
    zlib
  ];

  cmakeFlags = [
    "-DWITH_SYSTEM_FFMPEG=1"
    "-DWITH_SYSTEM_PNG=on"
    "-DWITH_SYSTEM_ZLIB=on"
  ];

  postInstall = ''
    mkdir -p $out/bin
    ln -s $out/stepmania-5.1/stepmania $out/bin/stepmania

    mkdir -p $out/share/
    cp -r $src/icons $out/share/

    install -Dm444 $src/stepmania.desktop -t $out/share/applications
  '';

  meta = {
    homepage = "https://www.stepmania.com/";
    description = "Free dance and rhythm game for Windows, Mac, and Linux";
    platforms = lib.platforms.linux;
    license = lib.licenses.mit; # expat version
    maintainers = with lib.maintainers; [ h7x4 ];
    mainProgram = "stepmania";
  };
}
