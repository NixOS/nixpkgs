{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  alsa-lib,
  freetype,
  libjack2,
  lv2,
  libX11,
  libXcursor,
  libXext,
  libXinerama,
  libXrandr,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "surge-XT";
  version = "1.3.4";

  src = fetchFromGitHub {
    owner = "surge-synthesizer";
    repo = "surge";
    tag = "release_xt_${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-4b0H3ZioiXFc4KCeQReobwQZJBl6Ep2/8JlRIwvq/hQ=";
  };

  postPatch = ''
    # see https://github.com/NixOS/nixpkgs/pull/149487#issuecomment-991747333
    export XDG_DOCUMENTS_DIR=$(mktemp -d)

    # Required for CMake 4
    # NOTE: libsamplerate is no longer used in Surge-XT, remove on package update
    substituteInPlace libs/libsamplerate/CMakeLists.txt --replace-fail \
      'cmake_minimum_required(VERSION 3.1..3.18)' \
      'cmake_minimum_required(VERSION 4.0)'
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    alsa-lib
    freetype
    libjack2
    lv2
    libX11
    libXcursor
    libXext
    libXinerama
    libXrandr
  ];

  enableParallelBuilding = true;

  cmakeFlags = [
    "-DSURGE_BUILD_LV2=TRUE"
  ];

  # JUCE dlopen's these at runtime, crashes without them
  NIX_LDFLAGS = (
    toString [
      "-lX11"
      "-lXext"
      "-lXcursor"
      "-lXinerama"
      "-lXrandr"
    ]
  );

  meta = {
    description = "LV2 & VST3 synthesizer plug-in (previously released as Vember Audio Surge)";
    homepage = "https://surge-synthesizer.github.io";
    license = lib.licenses.gpl3;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [
      magnetophon
      orivej
      mrtnvgr
    ];
  };
})
