{
  stdenv,
  lib,
  fetchFromGitHub,
  gitUpdater,
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

  buildVST3 ? true,
  buildLV2 ? true,
  buildCLAP ? true,
  buildStandalone ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "surge-XT";
  version = "1.3.4";

  src = fetchFromGitHub {
    owner = "surge-synthesizer";
    repo = "surge";
    tag = "${finalAttrs.finalPackage.passthru.rev-prefix}${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-4b0H3ZioiXFc4KCeQReobwQZJBl6Ep2/8JlRIwvq/hQ=";
  };

  patches = [
    # NOTE: merged in upstream, remove on package update
    #     (https://github.com/surge-synthesizer/surge/pull/8202)
    ./clap-option.diff
  ];

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
    libX11
    libXcursor
    libXext
    libXinerama
    libXrandr
  ]
  ++ lib.optionals buildLV2 [ lv2 ];

  enableParallelBuilding = true;

  cmakeFlags = [
    (lib.cmakeBool "SURGE_SKIP_STANDALONE" (!buildStandalone))
    (lib.cmakeBool "SURGE_SKIP_VST3" (!buildVST3))
    (lib.cmakeBool "SURGE_SKIP_LV2" buildLV2)
    (lib.cmakeBool "SURGE_BUILD_CLAP" buildCLAP)
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

  passthru = {
    rev-prefix = "release_xt_";
    updateScript = gitUpdater {
      inherit (finalAttrs.finalPackage.passthru) rev-prefix;
    };
  };

  meta = {
    description = "LV2 & VST3 synthesizer plug-in (previously released as Vember Audio Surge)";
    homepage = "https://surge-synthesizer.github.io";
    license = lib.licenses.gpl3;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [
      magnetophon
      mrtnvgr
    ];
  };
})
