{
  lib,
  fetchFromGitHub,
  stdenv,
  cmake,
  pkg-config,
  protobuf,
  python3Packages,
  ffmpeg,
  libopus,
  kdePackages,
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
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "chiaki-ng";
  version = "1.9.8";

  src = fetchFromGitHub {
    owner = "streetpea";
    repo = "chiaki-ng";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HQmXbi2diewA/+AMjlkyffvD73TkX6D+lMh+FL2Rcz4=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    kdePackages.wrapQtAppsHook
    protobuf
  ]
  ++ (with python3Packages; [
    wrapPython
    protobuf
    setuptools
  ]);

  buildInputs = [
    ffmpeg
    libopus
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
  ]
  ++ (with kdePackages; [
    qtbase
    qtmultimedia
    qtsvg
    qtdeclarative
    qtwayland
    qtwebengine
  ]);

  # handle library name discrepancy when curl not built with cmake
  postPatch = ''
    substituteInPlace lib/CMakeLists.txt \
      --replace-fail 'libcurl_shared' 'libcurl'
  '';

  cmakeFlags = [
    "-Wno-dev"
    (lib.cmakeFeature "CHIAKI_USE_SYSTEM_CURL" "true")
  ];

  qtWrapperArgs = [
    "--prefix LD_LIBRARY_PATH : ${vulkan-loader}/lib"
  ];

  pythonPath = [
    python3Packages.requests
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
