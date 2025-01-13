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

stdenv.mkDerivation rec {
  pname = "libopenglrecorder";
  version = "unstable-2020-08-13";

  src = fetchFromGitHub {
    owner = "Benau";
    repo = "libopenglrecorder";
    rev = "c1b81ce26e62fae1aaa086b5cd337cb12361ea3d";
    sha256 = "13s2d7qs8z4w0gb3hx03n97xmwl07d4s473m4gw90qcvmz217kiz";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs =
    [
      libjpeg
      libvpx
      openh264
    ]
    ++ lib.optionals withPulse [
      libpulseaudio
      libvorbis
    ];

  meta = with lib; {
    description = "Library allowing Optional async readback OpenGL frame buffer with optional audio recording";
    homepage = "https://github.com/Benau/libopenglrecorder";
    license = licenses.bsd3;
    maintainers = with maintainers; [ OPNA2608 ];
    platforms = with platforms; windows ++ linux;
  };
}
