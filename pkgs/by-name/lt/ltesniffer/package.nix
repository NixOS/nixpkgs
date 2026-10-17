{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  mkl,
  uhd,
  glib,
  srsran,
  soapysdr,
  libbladeRF,
  boost,
  fftwFloat,
  libsysprof-capture,
  pcre2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ltesniffer";
  version = "2.1.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "SysSec-KAIST";
    repo = "LTESniffer";
    tag = "LTESniffer-v${finalAttrs.version}";
    hash = "sha256-s5w8v5nrAv2IK4rv7aukcDAXrol5P3wfWceSkCOGEAc=";
  };

  cmakeFlags = [
    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"

    "-DCMAKE_PROJECT_NAME=ltesniffer"
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    mkl
    uhd
    glib
    srsran
    soapysdr
    libbladeRF
    boost
    fftwFloat
    libsysprof-capture
    pcre2
  ];

  meta = {
    description = "Open-source LTE Downlink/Uplink Eavesdropper";
    homepage = "https://github.com/SysSec-KAIST/LTESniffer";
    license = lib.licenses.agpl3Only;
  };
})
