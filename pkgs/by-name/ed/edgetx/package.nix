{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  cmake,
  ninja,
  libsForQt5,
  SDL2,
  fox_1_6,
  replaceVars,
  llvmPackages,
  dfu-util,
  gtest,
  miniz,
  yaml-cpp,
  udevCheckHook,
  applyPatches,
  # List of targets to build simulators for
  targetsToBuild ? import ./targets.nix,
}:

let
  # Keep in sync with `cmake/FetchMaxLibQt.cmake`.
  maxlibqt = fetchFromGitHub {
    owner = "edgetx";
    repo = "maxLibQt";
    rev = "ac1988ffd005cd15a8449b92150ce6c08574a4f1";
    hash = "sha256-u8e4qseU0+BJyZkV0JE4sUiXaFeIYvadkMTGXXiE2Kg=";
  };

  pythonEnv = python3.withPackages (
    pyPkgs: with pyPkgs; [
      pillow
      lz4
      jinja2
      libclang
    ]
  );

  # paches are needed to fix build with CMake 4
  yaml-cppSrc = applyPatches {
    inherit (yaml-cpp) src;
    patches = yaml-cpp.patches or [ ];
  };
in

stdenv.mkDerivation (finalAttrs: {
  pname = "edgetx";
  version = "2.11.3";

  src = fetchFromGitHub {
    owner = "EdgeTX";
    repo = "edgetx";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-vlJsfebTWhdh6HDpUEA1QJJSVGMlcL49XFwIx4A9zHs=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pythonEnv
    libsForQt5.qttools
    libsForQt5.wrapQtAppsHook
    udevCheckHook
  ];

  buildInputs = [
    libsForQt5.qtbase
    libsForQt5.qtmultimedia
    libsForQt5.qtserialport
    SDL2
    fox_1_6
  ];

  patches = [
    (replaceVars ./0001-libclang-paths.patch (
      let
        llvmMajor = lib.versions.major llvmPackages.llvm.version;
      in
      {
        resourceDir = "${llvmPackages.clang.cc.lib}/lib/clang/${llvmMajor}";
        libclang = "${lib.getLib llvmPackages.libclang}/lib/libclang.so";
        libc-cflags = "${llvmPackages.clang}/nix-support/libc-cflags";
        libcxx-cflags = "${llvmPackages.clang}/nix-support/libcxx-cxxflags";
      }
    ))
  ];

  postPatch = ''
    sed -i companion/src/burnconfigdialog.cpp \
      -e 's|/usr/.*bin/dfu-util|${dfu-util}/bin/dfu-util|'
    patchShebangs companion/util radio/util
  '';

  doInstallCheck = true;

  cmakeFlags = [
    # Unvendoring these libraries is infeasible. At least lets reuse the same sources.
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_GOOGLETEST" "${gtest.src}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_MINIZ" "${miniz.src}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_YAML-CPP" "${yaml-cppSrc}")
    # Custom library https://github.com/edgetx/maxLibQt.
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_MAXLIBQT" "${maxlibqt}")
    (lib.cmakeFeature "DFU_UTIL_ROOT_DIR" "${lib.getBin dfu-util}/bin")
    # Superbuild machinery is only getting in the way.
    (lib.cmakeBool "EdgeTX_SUPERBUILD" false)
    # COMMON_OPTIONS from tools/build-companion.sh.
    (lib.cmakeBool "GVARS" true)
    (lib.cmakeBool "HELI" true)
    (lib.cmakeBool "LUA" true)
    # Build companion and not the firmware.
    (lib.cmakeBool "NATIVE_BUILD" true)
    # file RPATH_CHANGE could not write new RPATH.
    (lib.cmakeBool "CMAKE_SKIP_BUILD_RPATH" true)
  ];

  env = {
    EDGETX_VERSION_SUFFIX = "nixpkgs";
  };

  dontUseCmakeConfigure = true;
  inherit targetsToBuild;
  __structuredAttrs = true; # To pass targetsToBuild as an array.

  configurePhase = ''
    runHook preConfigure
    prependToVar cmakeFlags "-GNinja"
    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    cmakeCommonFlags="$''\{cmakeFlags[@]}"
    # This is the most sensible way to convert target name -> cmake options
    # aside from manually extracting bash variables from upstream's CI scripts
    # and converting that to nix expressions. Let's hope upstream doesn't break
    # this file too often.
    source $src/tools/build-common.sh

    # Yes, this is really how upstream expects packaging to look like ¯\_(ツ)_/¯.
    # https://github.com/EdgeTX/edgetx/wiki/Build-Instructions-under-Ubuntu-20.04#building-companion-simulator-and-radio-simulator-libraries
    for plugin in "$''\{targetsToBuild[@]''\}"
    do
      # Variable modified by `get_target_build_options` from build-common.sh.
      local BUILD_OPTIONS=""
      get_target_build_options "$plugin"
      # With each invocation of `cmakeConfigurePhase` `cmakeFlags` gets
      # prepended to, so it has to be reset.
      cmakeFlags=()
      appendToVar cmakeFlags $cmakeCommonFlags $BUILD_OPTIONS
      pushd .
      cmakeConfigurePhase
      ninjaFlags=("libsimulator")
      ninjaBuildPhase
      rm CMakeCache.txt
      popd
    done

    cmakeConfigurePhase
    ninjaFlags=()
    ninjaBuildPhase

    runHook postBuild
  '';

  meta = {
    description = "EdgeTX Companion transmitter support software";
    longDescription = ''
      EdgeTX Companion is used for many different tasks like loading EdgeTX
      firmware to the radio, backing up model settings, editing settings and
      running radio simulators.
    '';
    mainProgram = "companion" + lib.concatStrings (lib.take 2 (lib.splitVersion finalAttrs.version));
    homepage = "https://edgetx.org/";
    changelog = "https://github.com/EdgeTX/edgetx/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl2Only;
    platforms = [
      "i686-linux"
      "x86_64-linux"
      "aarch64-linux"
    ];
    maintainers = with lib.maintainers; [
      elitak
      lopsided98
      wucke13
      xokdvium
    ];
  };
})
