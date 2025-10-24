{
  lib,
  fetchFromGitHub,
  stdenv,
  cmake,
  pkg-config,
  protobuf,
  python3,
  ffmpeg,
  libopus,
  SDL2,
  libevdev,
  udev,
  curlFull,
  hidapi,
  json_c,
  fftw,
  miniupnpc,
  nanopb,
  speexdsp,
  libplacebo,
  vulkan-loader,
  vulkan-headers,
  libunwind,
  shaderc,
  lcms2,
  libdovi,
  xxHash,
  kdePackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "chiaki-ng";
  version = "1.9.9";

  src = fetchFromGitHub {
    owner = "streetpea";
    repo = "chiaki-ng";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7pDQnlElnBkW+Nr6R+NaylZbsGH8dB31nd7jxYD66yQ=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    kdePackages.wrapQtAppsHook
    protobuf
    python3
    python3.pkgs.wrapPython
    python3.pkgs.protobuf
    python3.pkgs.setuptools
  ];

  buildInputs = [
    ffmpeg
    libopus
    kdePackages.qtbase
    kdePackages.qtmultimedia
    kdePackages.qtsvg
    kdePackages.qtdeclarative
    kdePackages.qtwayland
    kdePackages.qtwebengine
    protobuf
    SDL2
    curlFull
    hidapi
    json_c
    fftw
    miniupnpc
    nanopb
    libevdev
    udev
    speexdsp
    libplacebo
    vulkan-headers
    libunwind
    shaderc
    lcms2
    libdovi
    xxHash
  ];

  cmakeFlags = [
    "-Wno-dev"
    (lib.cmakeFeature "CHIAKI_USE_SYSTEM_CURL" "true")
  ];

  qtWrapperArgs = [
    "--prefix LD_LIBRARY_PATH : ${vulkan-loader}/lib"
  ];

  pythonPath = [
    python3.pkgs.requests
  ];

  postInstall = ''
    install -Dm755 $src/scripts/psn-account-id.py $out/bin/psn-account-id
  '';

  postFixup = ''
    wrapPythonPrograms
  '';

  meta = {
    homepage = "https://streetpea.github.io/chiaki-ng/";
    description = "Next-Generation of Chiaki (the open-source remote play client for PlayStation)";
    # Includes OpenSSL linking exception that we currently have no way
    # to represent.
    #
    # See also: <https://github.com/spdx/license-list-XML/issues/939>
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ devusb ];
    platforms = lib.platforms.linux;
    mainProgram = "chiaki";
  };
})
