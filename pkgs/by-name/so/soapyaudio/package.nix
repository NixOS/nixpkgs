{
  lib,
  stdenv,
  fetchFromGitHub,
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
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "pothosware";
    repo = "SoapyAudio";
    rev = "soapy-audio-${finalAttrs.version}";
    sha256 = "sha256-0o1HxqzYhZY2qbG/YG7VbWvXqDHBs0hkpw/xRDm5AdM=";
  };

  strictDeps = true;
  __structuredAttrs = true;

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
