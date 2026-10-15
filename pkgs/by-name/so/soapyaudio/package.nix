{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  pkg-config,
  hamlib,
  rtaudio,
  alsa-lib,
  libpulseaudio,
  libjack2,
  libusb1,
  soapysdr,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "soapyaudio";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "pothosware";
    repo = "SoapyAudio";
    rev = "soapy-audio-${finalAttrs.version}";
    hash = "sha256-gEHV8Mqzj5O7yEsf7+jkGP17aiQLFruBqLhuGpimNlY=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    hamlib
    rtaudio
    libjack2
    libusb1
    soapysdr
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    libpulseaudio
  ];

  patches = [
    # CMake < 3.5.0 fix. Remove when (https://github.com/pothosware/SoapyAudio/pull/23 is merged && next version bump).
    (fetchpatch {
      url = "https://github.com/pothosware/SoapyAudio/pull/23/commits/265c6f043762810b369490398956c5e511ca5261.patch";
      hash = "sha256-eqx/7i7jewkHm0M54rtEhznDRN9iPeIlgwHMJY9pN9g=";
    })
  ];

  cmakeFlags = [
    "-DSoapySDR_DIR=${soapysdr}/share/cmake/SoapySDR/"
    "-DUSE_HAMLIB=ON"
  ];

  meta = {
    homepage = "https://github.com/pothosware/SoapyAudio";
    description = "SoapySDR plugin for amateur radio and audio devices";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ numinit ];
    platforms = lib.platforms.unix;
  };
})
