{
  lib,
  llvmPackages,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
  qt5,
  python3,
  nix-update-script,
  xxHash,
  fmt,
  nasm,
  buildEnv,
  runCommand,
  writeText,
  pkgsCross,
  libclang,
  libllvm,
  alsa-lib,
  libdrm,
  libGL,
  wayland,
  xorg,
}:

let
  pkgsCross32 = pkgsCross.gnu32;
  pkgsCross64 = pkgsCross.gnu64;
  devRootFSBase = buildEnv {
    name = "fex-dev-rootfs";
    paths = [
      # later stdenv seems to have shuffled around the headers
      # pkgsCross64.stdenv.cc.libc_dev
      # pkgsCross32.stdenv.cc.libc_dev
      # pkgsCross64.stdenv.cc.cc
      # pkgsCross32.stdenv.cc.cc
      pkgsCross64.gcc13Stdenv.cc.libc_dev
      pkgsCross32.gcc13Stdenv.cc.libc_dev
      pkgsCross64.gcc13Stdenv.cc.cc
      pkgsCross32.gcc13Stdenv.cc.cc

      alsa-lib.dev
      libdrm.dev
      libGL.dev
      wayland.dev
      xorg.libX11.dev
      xorg.libxcb.dev
      xorg.libXrandr.dev
      xorg.libXrender.dev
      xorg.xorgproto
    ];
    ignoreCollisions = true;
    pathsToLink = [
      "/include"
      "/lib"
    ];
  };

  devRootFS = runCommand "fex-dev-rootfs2" {} ''
    mkdir -p $out/usr
    ln -s ${devRootFSBase}/* $out/
    ln -s ${devRootFSBase}/include $out/usr/
  '';

  toolchain32 = writeText "toolchain_nix_x86_32.txt" "
    set(CMAKE_EXE_LINKER_FLAGS_INIT \"-fuse-ld=lld\")
    set(CMAKE_MODULE_LINKER_FLAGS_INIT \"-fuse-ld=lld\")
    set(CMAKE_SHARED_LINKER_FLAGS_INIT \"-fuse-ld=lld\")
    set(CMAKE_SYSTEM_PROCESSOR i686)
    set(CMAKE_C_COMPILER clang)
    set(CMAKE_CXX_COMPILER clang++)
    set(CLANG_FLAGS \"-nodefaultlibs -nostartfiles -lstdc++ -target i686-linux-gnu -msse2 -mfpmath=sse --sysroot=${devRootFS} -iwithsysroot/usr/include\")
    set(CMAKE_C_COMPILER ${pkgsCross32.buildPackages.clang}/bin/i686-unknown-linux-gnu-clang)
    set(CMAKE_CXX_COMPILER ${pkgsCross32.buildPackages.clang}/bin/i686-unknown-linux-gnu-clang++)
    set(CMAKE_C_FLAGS \"\${CMAKE_C_FLAGS} \${CLANG_FLAGS}\")
    set(CMAKE_CXX_FLAGS \"\${CMAKE_CXX_FLAGS} \${CLANG_FLAGS}\")
  ";

  toolchain = writeText "toolchain_nix_x86_64.txt" "
    set(CMAKE_EXE_LINKER_FLAGS_INIT \"-fuse-ld=lld\")
    set(CMAKE_MODULE_LINKER_FLAGS_INIT \"-fuse-ld=lld\")
    set(CMAKE_SHARED_LINKER_FLAGS_INIT \"-fuse-ld=lld\")
    set(CMAKE_SYSTEM_PROCESSOR x86_64)
    set(CMAKE_C_COMPILER clang)
    set(CMAKE_CXX_COMPILER clang++)
    set(CLANG_FLAGS \"-nodefaultlibs -nostartfiles -lstdc++ -target x86_64-linux-gnu --sysroot=${devRootFS} -iwithsysroot/usr/include\")
    set(CMAKE_C_COMPILER ${pkgsCross64.buildPackages.clang}/bin/x86_64-unknown-linux-gnu-clang)
    set(CMAKE_CXX_COMPILER ${pkgsCross64.buildPackages.clang}/bin/x86_64-unknown-linux-gnu-clang++)
    set(CMAKE_C_FLAGS \"\${CMAKE_C_FLAGS} \${CLANG_FLAGS}\")
    set(CMAKE_CXX_FLAGS \"\${CMAKE_CXX_FLAGS} \${CLANG_FLAGS}\")
  ";
in
llvmPackages.stdenv.mkDerivation (finalAttrs: {
  pname = "fex";
  # version = "2505";
  version = "5811914a784cc6fdfdc90242ab7f8ea6ff39ec38";

  src = fetchFromGitHub {
    owner = "neobrain";
    repo = "FEX";
    rev = "${finalAttrs.version}";
    # tag = "FEX-${finalAttrs.version}";

    hash = "sha256-4JDUdxVyuEkefqRamukKgFe8aX4aJs0fMLYCwh3BQS8=";
    leaveDotGit = true;
    postFetch = ''
      cd $out
      git reset

      # Only fetch required submodules
      git submodule update --init --depth 1 \
        External/Vulkan-Headers \
        External/drm-headers \
        External/jemalloc \
        External/jemalloc_glibc \
        External/robin-map \
        External/vixl \
        Source/Common/cpp-optparse \
        External/Catch2

      find . -name .git -print0 | xargs -0 rm -rf

      # Remove some more unnecessary directories
      rm -r \
        External/vixl/src/aarch32 \
        External/vixl/test
    '';
  };

  postPatch = ''
    substituteInPlace ThunkLibs/GuestLibs/CMakeLists.txt --replace "/usr/include/libdrm" "${devRootFS}/include/libdrm"
    substituteInPlace ThunkLibs/HostLibs/CMakeLists.txt --replace "/usr/include/libdrm" "${devRootFS}/include/libdrm"
    substituteInPlace ThunkLibs/GuestLibs/CMakeLists.txt --replace "/usr/include/wayland" "${devRootFS}/include/wayland"
    substituteInPlace ThunkLibs/HostLibs/CMakeLists.txt --replace "/usr/include/wayland" "${devRootFS}/include/wayland"

    # Add include paths for thunkgen invocation
    substituteInPlace ThunkLibs/HostLibs/CMakeLists.txt --replace "-- " "-- $(cat ${llvmPackages.stdenv.cc}/nix-support/libc-cflags) $(cat ${llvmPackages.stdenv.cc}/nix-support/libcxx-cxxflags) $NIX_CFLAGS_COMPILE"
  '';

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    qt5.wrapQtAppsHook
    llvmPackages.bintools

    (python3.withPackages (
      pythonPackages: with pythonPackages; [
        setuptools
        libclang
      ]
    ))
  ];

  nativeCheckInputs = [ nasm ];

  buildInputs =
    [
      xxHash
      fmt
      pkgsCross64.buildPackages.clang
      pkgsCross32.buildPackages.clang
      libclang
      libllvm

      # Headers required to build the ThunkLibs subtree
      alsa-lib.dev
      libdrm.dev
      libGL.dev
      wayland.dev
      xorg.libX11.dev
      xorg.libxcb.dev
      xorg.libXrandr.dev
      xorg.libXrender.dev
      xorg.xorgproto
    ]
    ++ (with qt5; [
      qtbase
      qtdeclarative
      qtquickcontrols
      qtquickcontrols2
    ]);

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_BUILD_TYPE" "Release")
    (lib.cmakeFeature "USE_LINKER" "lld")
    (lib.cmakeBool "ENABLE_LTO" true)
    (lib.cmakeBool "ENABLE_ASSERTIONS" false)
    (lib.cmakeFeature "OVERRIDE_VERSION" finalAttrs.version)
    (lib.cmakeBool "BUILD_TESTS" finalAttrs.finalPackage.doCheck)
    (lib.cmakeBool "BUILD_THUNKS" true)
    (lib.cmakeFeature "X86_32_TOOLCHAIN_FILE" "${toolchain32}")
    (lib.cmakeFeature "X86_64_TOOLCHAIN_FILE" "${toolchain}")
    (lib.cmakeFeature "X86_DEV_ROOTFS" "${devRootFS}")
    (lib.cmakeFeature "OVERRIDE_VERSION" "2506")
  ];

  strictDeps = true;

  # Unsupported on non-4K page size kernels (e.g. Apple Silicon)
  doCheck = true;

  # List not exhaustive, e.g. because they depend on an x86 compiler or some
  # other difficult-to-build test binaries.
  checkTarget = lib.concatStringsSep " " [
    "asm_tests"
    "api_tests"
    "fexcore_apitests"
    "emitter_tests"
  ];

  # placeholder build phase for quick testing
  # buildPhase = ''
  #   make drm-host-64 -j5
  #   make asound-host-64 -j5
  #   make wayland-client-host-64 -j5
  # '';

  # Avoid wrapping anything other than FEXConfig, since the wrapped executables
  # don't seem to work when registered as binfmts.
  dontWrapQtApps = true;
  preFixup = ''
    wrapQtApp $out/bin/FEXConfig
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Fast usermode x86 and x86-64 emulator for Arm64 Linux";
    homepage = "https://fex-emu.com/";
    changelog = "https://github.com/FEX-Emu/FEX/releases/tag/FEX-${finalAttrs.version}";
    platforms = [ "aarch64-linux" ];
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ andre4ik3 ];
    mainProgram = "FEXBash";
  };
})
