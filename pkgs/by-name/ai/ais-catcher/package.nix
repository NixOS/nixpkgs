{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  installShellFiles,
  rtl-sdr,
  libusb1,
  zlib,
  openssl,
  soxr,
  libsamplerate,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ais-catcher";
  version = "0.70";

  src = fetchFromGitHub {
    owner = "jvde-github";
    repo = "AIS-catcher";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YDkqIoW3DDwUfAJftvfnmsIQYCq9ujYrB8RvZRiIexg=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    installShellFiles
  ];

  buildInputs = [
    rtl-sdr
    libusb1
    zlib
    openssl
    soxr
    libsamplerate
  ];

  cmakeFlags = [
    (lib.cmakeBool "RTLSDR" true)
    (lib.cmakeBool "ZLIB" true)
    (lib.cmakeBool "OPENSSL" true)
    (lib.cmakeBool "SOXR" true)
    (lib.cmakeBool "SAMPLERATE" true)

    # Proprietary or otherwise unused SDR backends and features.
    (lib.cmakeBool "SOAPYSDR" false)
    (lib.cmakeBool "AIRSPY" false)
    (lib.cmakeBool "AIRSPYHF" false)
    (lib.cmakeBool "SDRPLAY" false)
    (lib.cmakeBool "HACKRF" false)
    (lib.cmakeBool "HYDRASDR" false)
    (lib.cmakeBool "ZMQ" false)
    (lib.cmakeBool "PSQL" false)
    (lib.cmakeBool "SQLITE" false)
    (lib.cmakeBool "NMEA2000" false)
    (lib.cmakeBool "WEBVIEWER" false)
  ];

  # Upstream ships no install rule; install the single binary directly.
  installPhase = ''
    runHook preInstall
    installBin AIS-catcher
    runHook postInstall
  '';

  meta = {
    description = "AIS receiver and decoder for RTL-SDR and other SDR hardware";
    homepage = "https://github.com/jvde-github/AIS-catcher";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.darkone ];
    mainProgram = "AIS-catcher";
    platforms = lib.platforms.linux;
  };
})
