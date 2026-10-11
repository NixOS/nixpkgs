{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  cmake,
  ninja,
  qt6,
  SDL2,
  fox_1_6,
  replaceVars,
  llvmPackages,
  gtest,
  miniz,
  yaml-cpp,
  imgui,
  udevCheckHook,
  applyPatches,
  callPackage,
  # List of targets to build simulators for
  targetsToBuild ? import ./targets.nix,
}:

let
  # Keep in sync with `cmake/FetchMaxLibQt.cmake`.
  maxlibqt = fetchFromGitHub {
    owner = "edgetx";
    repo = "maxLibQt";
    rev = "7e433da60d3f2e975d46afc91804a88029cd1b78";
    hash = "sha256-1Pl8TVBNLE97XJcP68A0+zVCvBlXt+mPFxjM9YbF8CU=";
  };

  rsDfu = callPackage ./rs-dfu.nix { };

  pythonEnv = python3.withPackages (
    pyPkgs: with pyPkgs; [
      pillow
      lz4
      jinja2
      clang
    ]
  );

  # patches are needed to fix build with CMake 4
  yaml-cppSrc = applyPatches {
    inherit (yaml-cpp) src;
    patches = yaml-cpp.patches or [ ];
  };
in

stdenv.mkDerivation (finalAttrs: {
  pname = "edgetx";
  version = "2.12.4";

  src = fetchFromGitHub {
    owner = "EdgeTX";
    repo = "edgetx";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-0YqjhUE1QoFXikvBocgqzqzk+oiUh5zzGt3EP6rDKVI=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pythonEnv
    qt6.qttools
    qt6.wrapQtAppsHook
    udevCheckHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtmultimedia
    qt6.qtserialport
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
    patchShebangs companion/util radio/util
  '';

  doInstallCheck = true;

  cmakeFlags = [
    # Unvendoring these libraries is infeasible. At least lets reuse the same sources.
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_GOOGLETEST" "${gtest.src}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_MINIZ" "${miniz.src}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_YAML-CPP" "${yaml-cppSrc}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_RSDFU" "${rsDfu}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_IMGUI" "${imgui.src}")
    (lib.cmakeBool "FETCHCONTENT_FULLY_DISCONNECTED" true)
    # Custom library https://github.com/edgetx/maxLibQt.
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_MAXLIBQT" "${maxlibqt}")
    # Superbuild machinery is only getting in the way.
    (lib.cmakeBool "EdgeTX_SUPERBUILD" false)
    # Build companion and not the firmware.
    (lib.cmakeBool "NATIVE_BUILD" true)
    # file RPATH_CHANGE could not write new RPATH.
    (lib.cmakeBool "CMAKE_SKIP_BUILD_RPATH" true)
    # Upstream doesn't handle absolute BINDIR paths...
    (lib.cmakeFeature "CMAKE_INSTALL_BINDIR" "bin")
  ];

  env = {
    EDGETX_VERSION_TAG = "${finalAttrs.version}";
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

    cmakeCommonFlags="''${cmakeFlags[@]}"
    # This is the most sensible way to convert target name -> cmake options
    # aside from manually extracting bash variables from upstream's CI scripts
    # and converting that to nix expressions. Let's hope upstream doesn't break
    # this file too often.
    source $src/tools/build-common.sh

    # Yes, this is really how upstream expects packaging to look like ¯\_(ツ)_/¯.
    # https://github.com/EdgeTX/edgetx/wiki/Build-Instructions-under-Ubuntu-20.04#building-companion-simulator-and-radio-simulator-libraries
    for plugin in "''${targetsToBuild[@]}"
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

  postInstall = ''
    # What in god's name is upstreaming doing?
    rm -rf $out/lib/libcrypto.* $out/lib/libssl.*
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
      lopsided98
      wucke13
      xokdvium
    ];
  };
})
