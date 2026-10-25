{
  lib,
  stdenv,
  fetchFromGitHub,
  callPackage,
  cmake,
  pkg-config,
  csound,
  csound-plugins,
  alsa-lib,
  eigen,
  faust,
  fluidsynth,
  gmm,
  gtest,
  hdf5,
  libpng,
  libwebsockets,
  ocl-icd,
  opencl-headers,
  openssl,
  python3,
  wiiuse,
  plugins ? [
    "chua"
    "faust"
    "fluid"
    "hdf5"
    "image"
    "linear-algebra"
    "opencl"
    "python"
    "stk"
    "websocket"
    "wiimote"
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux "dssi",
}:

let
  pluginOptions = {
    chua = {
      flag = "BUILD_CHUA_OPCODES";
      dependencies = [ eigen ];
    };
    dssi = {
      flag = "BUILD_DSSI_OPCODES";
      dependencies = [ alsa-lib ];
    };
    faust = {
      flag = "BUILD_FAUST_OPCODES";
      dependencies = [ faust ];
    };
    fluid = {
      flag = "BUILD_FLUID_OPCODES";
      dependencies = [ fluidsynth ];
    };
    hdf5 = {
      flag = "BUILD_HDF5_OPCODES";
      dependencies = [ hdf5 ];
    };
    image = {
      flag = "BUILD_IMAGE_OPCODES";
      dependencies = [ libpng ];
    };
    linear-algebra = {
      flag = "BUILD_LINEAR_ALGEBRA_OPCODES";
      dependencies = [ gmm ];
    };
    opencl = {
      flag = "BUILD_OPENCL_OPCODES";
      dependencies = lib.optionals (!stdenv.hostPlatform.isDarwin) [
        ocl-icd
        opencl-headers
      ];
    };
    python = {
      flag = "BUILD_PYTHON_OPCODES";
      dependencies = [ python3 ];
    };
    stk = {
      flag = "BUILD_STK_OPCODES";
      dependencies = [ ];
    };
    websocket = {
      flag = "BUILD_WEBSOCKET_OPCODE";
      dependencies = [
        libwebsockets
        openssl
      ];
    };
    wiimote = {
      flag = "BUILD_WIIMOTE_OPCODES";
      dependencies = [ wiiuse ];
    };
  };
in
assert lib.assertMsg (lib.all (name: builtins.hasAttr name pluginOptions) plugins)
  "csound-plugins: plugins must be selected from ${lib.concatStringsSep ", " (lib.attrNames pluginOptions)}";

stdenv.mkDerivation (finalAttrs: {
  pname = "csound-plugins" + lib.optionalString (lib.length plugins == 1) "-${lib.head plugins}";
  version = "0-unstable-2026-10-18";

  # The latest tag predates most Csound 7 plugin ports and Python API fixes.
  src = fetchFromGitHub {
    owner = "csound";
    repo = "plugins";
    rev = "7e4af2e966cf10cb25469224ff15b5241bd455d8";
    hash = "sha256-VgdycZXXiAbq82SiZIM/gCKvIqesBS59KZQqScaQaj0=";
  };

  sourceRoot = "${finalAttrs.src.name}/7.x";

  __structuredAttrs = true;
  strictDeps = true;

  patches = [
    # Match Csound 7's const type descriptors and required plugin ABI metadata.
    ./csound-7-api.patch
    # Avoid unused iterative solvers in gmm.h that require optional MUMPS headers.
    ./gmm-headers.patch
  ];

  postPatch = ''
    # Reuse Faust's standard library instead of copying its full share directory.
    substituteInPlace src/faustcsound/CMakeLists.txt \
      --replace-fail 'DESTINATION "''${PLUGIN_INSTALL_DIR}/faust")' \
        'DESTINATION "''${PLUGIN_INSTALL_DIR}/faust" EXCLUDE_FROM_ALL)' \
      --replace-fail 'DEFAULT_FAUST_LIB_PATH=\"''${PLUGIN_INSTALL_DIR}/faust\"' \
        'DEFAULT_FAUST_LIB_PATH=\"''${FAUST_STDLIB_DIR}\"'
  ''
  # Clang 21's SLP vectorizer crashes on gmm's complex QR routine.
  + lib.optionalString (stdenv.cc.isClang && lib.versions.major stdenv.cc.version == "21") ''
    substituteInPlace src/linear_algebra/CMakeLists.txt \
      --replace-fail 'target_compile_definitions(linear_algebra PRIVATE BUILD_PLUGINS)' \
        'target_compile_definitions(linear_algebra PRIVATE BUILD_PLUGINS)
        target_compile_options(linear_algebra PRIVATE -fno-slp-vectorize)'
  ''
  # Upstream installs macOS plugins into the user's home directory.
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace CMakeLists.txt \
      --replace-fail '$ENV{HOME}/Library/csound/''${APIVERSION}/plugins64' \
        "${placeholder "out"}/lib/csound/plugins64-7.0" \
      --replace-fail '$ENV{HOME}/Library/csound/''${APIVERSION}/plugins' \
        "${placeholder "out"}/lib/csound/plugins-7.0"
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ]
  ++ lib.optional (lib.elem "python" plugins) python3;

  buildInputs = [ csound ] ++ lib.concatMap (name: pluginOptions.${name}.dependencies) plugins;

  cmakeFlags = [
    (lib.cmakeBool "FAIL_MISSING" true)
    # Use stdenv's CPU flags; upstream adds x86 flags on every platform.
    (lib.cmakeBool "USE_COMPILER_OPTIMIZATIONS" false)
    (lib.cmakeBool "USE_DOUBLE" true)
    (lib.cmakeBool "BUILD_CUDA_OPCODES" false)
    (lib.cmakeBool "BUILD_P5GLOVE_OPCODES" false)
  ]
  ++ lib.mapAttrsToList (name: value: lib.cmakeBool value.flag (lib.elem name plugins)) pluginOptions
  ++ lib.optional (lib.elem "linear-algebra" plugins) (
    lib.cmakeFeature "GMM_INCLUDE_PATH" "${gmm}/include"
  )
  ++ lib.optional (lib.elem "faust" plugins) (
    lib.cmakeFeature "FAUST_STDLIB_DIR_HINT" "${faust}/share/faust"
  )
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    (lib.cmakeFeature "CSOUND_INCLUDE_DIR_HINT" "${csound}/lib/CsoundLib64.framework/Headers")
    (lib.cmakeFeature "CSOUND_LIBRARY" "${csound}/lib/CsoundLib64.framework/CsoundLib64")
  ];

  checkInputs = [ gtest ];
  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  passthru = {
    plugins = lib.genAttrs (lib.attrNames pluginOptions) (
      name:
      csound-plugins.override {
        inherit csound;
        plugins = [ name ];
      }
    );
    tests = callPackage ./tests.nix {
      inherit csound plugins;
      csound-plugins = finalAttrs.finalPackage;
    };
  };

  meta = {
    description = "Opcode plugins for Csound 7";
    homepage = "https://github.com/csound/plugins";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ hlolli ];
    platforms = lib.platforms.linux ++ lib.optionals (!(lib.elem "dssi" plugins)) lib.platforms.darwin;
  };
})
