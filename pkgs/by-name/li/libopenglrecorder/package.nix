{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libjpeg,
  libvpx,
  openh264,
  withPulse ? stdenv.hostPlatform.isLinux,
  libpulseaudio,
  libvorbis,
}:

stdenv.mkDerivation {
  pname = "libopenglrecorder";
  version = "0.1.0-unstable-2025-10-07";

  src = fetchFromGitHub {
    owner = "Benau";
    repo = "libopenglrecorder";
    rev = "6101627e9952ec1a835dad38475f281878526052";
    hash = "sha256-GTwj0StGvcxEH9JX5W1H+eUj8c6mankGuil+QqCv8QM=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    libjpeg
    libvpx
    openh264
  ]
  ++ lib.optionals withPulse [
    libpulseaudio
    libvorbis
  ];

  meta = {
    description = "Library allowing Optional async readback OpenGL frame buffer with optional audio recording";
    homepage = "https://github.com/Benau/libopenglrecorder";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ OPNA2608 ];
    platforms = with lib.platforms; windows ++ linux;
  };
}
