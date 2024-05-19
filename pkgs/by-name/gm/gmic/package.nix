{
  lib,
  cimg,
  cmake,
  common-updater-scripts,
  coreutils,
  curl,
  fetchFromGitHub,
  fetchurl,
  fftw,
  gmic-qt,
  gnugrep,
  gnused,
  graphicsmagick,
  jq,
  libjpeg,
  libpng,
  libtiff,
  ninja,
  opencv,
  openexr,
  pkg-config,
  runtimeShell,
  stdenv,
  substituteAll,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gmic";
  version = "3.3.5";

  outputs = [
    "out"
    "lib"
    "dev"
    "man"
  ];

  src = fetchFromGitHub {
    owner = "GreycLab";
    repo = "gmic";
    rev = "v.${finalAttrs.version}";
    hash = "sha256-881+o6Wz4yNf92JNNLQn9x44SSjXAp/cZLkBGCfM6DY=";
  };

  # TODO: build this from source
  # Reference: src/Makefile, directive gmic_stdlib_community.h
  gmic_stdlib = fetchurl {
    name = "gmic_stdlib_community.h";
    url = "http://gmic.eu/gmic_stdlib_community${
      lib.replaceStrings [ "." ] [ "" ] finalAttrs.version
    }.h";
    hash = "sha256-UZzCAs+x9dVMeaeEvPgyVZ5S6UO0yhJWVMgBvBiW2ME=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ];

  buildInputs = [
    cimg
    fftw
    graphicsmagick
    libjpeg
    libpng
    libtiff
    opencv
    openexr
    zlib
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_LIB_STATIC" false)
    (lib.cmakeBool "ENABLE_CURL" false)
    (lib.cmakeBool "ENABLE_DYNAMIC_LINKING" true)
    (lib.cmakeBool "USE_SYSTEM_CIMG" true)
  ];

  postPatch =
    ''
      cp -r ${finalAttrs.gmic_stdlib} src/gmic_stdlib_community.h
    ''
    + lib.optionalString stdenv.isDarwin ''
      substituteInPlace CMakeLists.txt \
        --replace "LD_LIBRARY_PATH" "DYLD_LIBRARY_PATH"
    '';

  passthru = {
    tests = {
      # Needs to update them all in lockstep.
      inherit cimg gmic-qt;
    };

    updateScript = substituteAll {
      src = ./update-script.sh;
      inherit runtimeShell;
      inherit (finalAttrs) version;
      pathTools = lib.makeBinPath [
        common-updater-scripts
        coreutils
        curl
        gnugrep
        gnused
        jq
      ];
    };
  };

  meta = {
    homepage = "https://gmic.eu/";
    description = "Open and full-featured framework for image processing";
    mainProgram = "gmic";
    license = lib.licenses.cecill21;
    maintainers = with lib.maintainers; [
      AndersonTorres
      lilyinstarlight
    ];
    platforms = lib.platforms.unix;
  };
})
