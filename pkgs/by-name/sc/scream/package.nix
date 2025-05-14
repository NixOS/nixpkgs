{
  stdenv,
  lib,
  config,
  fetchFromGitHub,
  cmake,
  pkg-config,
  alsaSupport ? stdenv.hostPlatform.isLinux,
  alsa-lib,
  pulseSupport ? config.pulseaudio or stdenv.hostPlatform.isLinux,
  libpulseaudio,
  jackSupport ? false,
  libjack2,
  soxr,
  pcapSupport ? false,
  libpcap,
}:

stdenv.mkDerivation rec {
  pname = "scream";
  version = "4.0";

  src = fetchFromGitHub {
    owner = "duncanthrax";
    repo = "scream";
    rev = version;
    sha256 = "sha256-lP5mdNhZjkEVjgQUEsisPy+KXUqsE6xj6dFWcgD+VGM=";
  };

  buildInputs =
    lib.optional pulseSupport libpulseaudio
    ++ lib.optionals jackSupport [
      libjack2
      soxr
    ]
    ++ lib.optional alsaSupport alsa-lib
    ++ lib.optional pcapSupport libpcap;
  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  cmakeFlags = [
    "-DPULSEAUDIO_ENABLE=${if pulseSupport then "ON" else "OFF"}"
    "-DALSA_ENABLE=${if alsaSupport then "ON" else "OFF"}"
    "-DJACK_ENABLE=${if jackSupport then "ON" else "OFF"}"
    "-DPCAP_ENABLE=${if pcapSupport then "ON" else "OFF"}"
  ];

  cmakeDir = "../Receivers/unix";

  doInstallCheck = true;
  installCheckPhase = ''
    set +o pipefail

    # Programs exit with code 1 when testing help, so grep for a string
    $out/bin/scream -h 2>&1 | grep -q Usage:
  '';

  meta = with lib; {
    description = "Audio receiver for the Scream virtual network sound card";
    homepage = "https://github.com/duncanthrax/scream";
    license = licenses.mspl;
    platforms = platforms.linux;
    mainProgram = "scream";
    maintainers = with maintainers; [ arcnmx ];
  };
}
