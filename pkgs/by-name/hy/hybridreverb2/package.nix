{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  lv2,
  alsa-lib,
  libjack2,
  freetype,
  libX11,
  gtk3,
  pcre,
  libpthreadstubs,
  libXdmcp,
  libxkbcommon,
  libepoxy,
  at-spi2-core,
  dbus,
  curl,
  fftwFloat,
}:

let
  pname = "HybridReverb2";
  version = "2.1.2-unstable-2021-12-19";
  rev = "2fc44c419f90133b3fcde71820212b5f281a0ad2";
  owner = "jpcima";
  DBversion = "1.0.0";
in

stdenv.mkDerivation rec {
  inherit pname version;

  impulseDB = fetchFromGitHub {
    inherit owner;
    repo = "HybridReverb2-impulse-response-database";
    rev = "v${DBversion}";
    sha256 = "sha256-PyGrMNhrL2cRjb2UPPwEaJ6vZBV2sDG1mKFCNdfqjsI=";
  };

  src = fetchFromGitHub {
    inherit owner;
    repo = "HybridReverb2";
    rev = rev;
    hash = "sha256-+uwTKHQ3nIWKbBCPtf/axvyW6MU0gemVtd2ZqqiT/w0=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    pkg-config
    cmake
  ];
  buildInputs = [
    lv2
    alsa-lib
    libjack2
    freetype
    libX11
    gtk3
    pcre
    libpthreadstubs
    libXdmcp
    libxkbcommon
    libepoxy
    at-spi2-core
    dbus
    curl
    fftwFloat
  ];

  cmakeFlags = [
    "-DHybridReverb2_AdvancedJackStandalone=ON"
    "-DHybridReverb2_UseLocalDatabase=ON"
  ];

  enableParallelBuilding = true;

  postInstall = ''
    mkdir -p $out/share/HybridReverb2/
    cp  -r ${impulseDB}/* $out/share/HybridReverb2/
  '';

  meta = with lib; {
    homepage = "https://github.com/jpcima/HybridReverb2";
    description = "Reverb effect using hybrid impulse convolution";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
    mainProgram = "HybridReverb2";
  };
}
