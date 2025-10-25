{
  lib,
  llvmPackages,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
  python3,
  nix-update-script,
  xxHash,
  fmt,
  libxml2,
  openssl,
  range-v3,
  catch2_3,
  nasm,
  buildEnv,
  writeText,
  pkgsCross,
  libclang,
  libllvm,
  alsa-lib,
  libdrm,
  libGL,
  wayland,
  xorg,
  withQt ? true,
  qt6,
  fetchpatch,
}:

let
  # Headers required to build the ThunkLibs subtree
  libForwardingInputs = lib.map lib.getInclude [
    alsa-lib
    libdrm
    libGL
    wayland
    xorg.libX11
    xorg.libxcb
    xorg.libXrandr
    xorg.libXrender
    xorg.xorgproto
  ];

  pkgsCross32 = pkgsCross.gnu32;
  pkgsCross64 = pkgsCross.gnu64;
  devRootFS = buildEnv {
    name = "fex-dev-rootfs";
    paths = [
      pkgsCross64.stdenv.cc.libc_dev
      pkgsCross32.stdenv.cc.libc_dev
      pkgsCross64.stdenv.cc.cc
      pkgsCross32.stdenv.cc.cc
    ]
    ++ libForwardingInputs;
    ignoreCollisions = true;
    pathsToLink = [
      "/include"
      "/lib"
    ];

    postBuild = ''
      mkdir -p $out/usr
      ln -s $out/include $out/usr/
    '';
  };

  toolchain32 = writeText "toolchain_nix_x86_32.txt" ''
    set(CMAKE_EXE_LINKER_FLAGS_INIT "-fuse-ld=lld")
    set(CMAKE_MODULE_LINKER_FLAGS_INIT "-fuse-ld=lld")
    set(CMAKE_SHARED_LINKER_FLAGS_INIT "-fuse-ld=lld")
    set(CMAKE_SYSTEM_PROCESSOR i686)
    set(CMAKE_C_COMPILER clang)
    set(CMAKE_CXX_COMPILER clang++)
    set(CMAKE_C_COMPILER ${pkgsCross32.buildPackages.clang}/bin/i686-unknown-linux-gnu-clang)
    set(CMAKE_CXX_COMPILER ${pkgsCross32.buildPackages.clang}/bin/i686-unknown-linux-gnu-clang++)
    set(CLANG_FLAGS "-nodefaultlibs -nostartfiles -target i686-linux-gnu -msse2 -mfpmath=sse --sysroot=${devRootFS} -iwithsysroot/usr/include")
    set(CMAKE_C_FLAGS "''${CMAKE_C_FLAGS} ''${CLANG_FLAGS}")
    set(CMAKE_CXX_FLAGS "''${CMAKE_CXX_FLAGS} ''${CLANG_FLAGS}")
  '';

  toolchain = writeText "toolchain_nix_x86_64.txt" ''
    set(CMAKE_EXE_LINKER_FLAGS_INIT "-fuse-ld=lld")
    set(CMAKE_MODULE_LINKER_FLAGS_INIT "-fuse-ld=lld")
    set(CMAKE_SHARED_LINKER_FLAGS_INIT "-fuse-ld=lld")
    set(CMAKE_SYSTEM_PROCESSOR x86_64)
    set(CMAKE_C_COMPILER clang)
    set(CMAKE_CXX_COMPILER clang++)
    set(CMAKE_C_COMPILER ${pkgsCross64.buildPackages.clang}/bin/x86_64-unknown-linux-gnu-clang)
    set(CMAKE_CXX_COMPILER ${pkgsCross64.buildPackages.clang}/bin/x86_64-unknown-linux-gnu-clang++)
    set(CLANG_FLAGS "-nodefaultlibs -nostartfiles -target x86_64-linux-gnu --sysroot=${devRootFS} -iwithsysroot/usr/include")
    set(CMAKE_C_FLAGS "''${CMAKE_C_FLAGS} ''${CLANG_FLAGS}")
    set(CMAKE_CXX_FLAGS "''${CMAKE_CXX_FLAGS} ''${CLANG_FLAGS}")
  '';
in
llvmPackages.stdenv.mkDerivation (finalAttrs: {
  pname = "fex";
  version = "2510";

  src = fetchFromGitHub {
    owner = "FEX-Emu";
    repo = "FEX";
    tag = "FEX-${finalAttrs.version}";
    hash = "sha256-C6Yeqo+KqA6OezxnpBAncTekOrPTgIq0vikQOmxaORA=";

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
        Source/Common/cpp-optparse

      find . -name .git -print0 | xargs -0 rm -rf

      # Remove some more unnecessary directories
      rm -r \
        External/vixl/src/aarch32 \
        External/vixl/test
    '';
  };

  patches = [
    # Backported fix of unit test build with LLVM 21.
    # TODO: drop after next release
    (fetchpatch {
      name = "unittests-thunklibs-fix-build-with-llvm-21.patch";
      url = "https://github.com/FEX-Emu/FEX/commit/5af2477d005bb0ab8b11633a678ed5f6121f81b6.patch";
      hash = "sha256-QdJaexzBSOVaKc3h2uwPbX4iysqvGBDmWH938ZeXcdE=";
    })
  ];

  postPatch = ''
    substituteInPlace ThunkLibs/GuestLibs/CMakeLists.txt ThunkLibs/HostLibs/CMakeLists.txt \
      --replace-fail "/usr/include/libdrm" "${devRootFS}/include/libdrm" \
      --replace-fail "/usr/include/wayland" "${devRootFS}/include/wayland"

    # Add include paths for thunkgen invocation
    substituteInPlace ThunkLibs/HostLibs/CMakeLists.txt \
      --replace-fail "-- " "-- $(cat ${llvmPackages.stdenv.cc}/nix-support/libc-cflags) $(cat ${llvmPackages.stdenv.cc}/nix-support/libcxx-cxxflags) ${
        lib.concatMapStrings (x: "-isystem " + x + "/include ") libForwardingInputs
      }"
    substituteInPlace ThunkLibs/GuestLibs/CMakeLists.txt \
      --replace-fail "-- " "-- $(cat ${llvmPackages.stdenv.cc}/nix-support/libcxx-cxxflags) "

    # Patch any references to library wrapper paths
    substituteInPlace FEXCore/Source/Interface/Config/Config.json.in \
      --replace-fail "ThunkGuestLibs" "UnusedThunkGuestLibs" \
      --replace-fail "ThunkHostLibs" "UnusedThunkHostLibs"
    substituteInPlace FEXCore/Source/Interface/Config/Config.cpp \
      --replace-fail "FEXCore::Config::CONFIG_THUNKGUESTLIBS" "FEXCore::Config::CONFIG_UNUSEDTHUNKGUESTLIBS" \
      --replace-fail "FEXCore::Config::CONFIG_THUNKHOSTLIBS" "FEXCore::Config::CONFIG_UNUSEDTHUNKHOSTLIBS"
    substituteInPlace Source/Tools/LinuxEmulation/VDSO_Emulation.cpp \
      --replace-fail "FEX_CONFIG_OPT(ThunkGuestLibs, THUNKGUESTLIBS);" "auto ThunkGuestLibs = []() { return \"$out/share/fex-emu/GuestThunks/\"; };"
    substituteInPlace Source/Tools/LinuxEmulation/LinuxSyscalls/FileManagement.h \
      --replace-fail "FEX_CONFIG_OPT(ThunkGuestLibs, THUNKGUESTLIBS);" "fextl::string ThunkGuestLibs() { return \"$out/share/fex-emu/GuestThunks/\"; }"
    substituteInPlace Source/Tools/LinuxEmulation/Thunks.cpp \
      --replace-fail "FEX_CONFIG_OPT(ThunkHostLibsPath, THUNKHOSTLIBS);" "fextl::string ThunkHostLibsPath() { return \"$out/lib/fex-emu/HostThunks/\"; }"
    substituteInPlace Source/Tools/FEXConfig/main.qml \
      --replace-fail "config: \"Thunk" "config: \"UnusedThunk" \
      --replace-fail "title: qsTr(\"Library forwarding:\")" "visible: false; title: qsTr(\"Library forwarding:\")"
  '';

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    llvmPackages.bintools
    (python3.withPackages (
      pythonPackages: with pythonPackages; [
        setuptools
        libclang
      ]
    ))
  ]
  ++ lib.optional withQt qt6.wrapQtAppsHook;

  buildInputs = [
    xxHash
    fmt
    libxml2
    openssl
    range-v3
    pkgsCross64.buildPackages.clang
    pkgsCross32.buildPackages.clang
    libclang
    libllvm
  ]
  ++ libForwardingInputs
  ++ lib.optionals withQt [
    qt6.qtbase
    qt6.qtdeclarative
  ];

  cmakeFlags = [
    (lib.cmakeFeature "USE_LINKER" "lld")
    (lib.cmakeFeature "OVERRIDE_VERSION" finalAttrs.version)
    (lib.cmakeBool "BUILD_TESTING" finalAttrs.finalPackage.doCheck)
    (lib.cmakeBool "BUILD_THUNKS" true)
    (lib.cmakeBool "BUILD_FEXCONFIG" withQt)
    (lib.cmakeFeature "X86_32_TOOLCHAIN_FILE" "${toolchain32}")
    (lib.cmakeFeature "X86_64_TOOLCHAIN_FILE" "${toolchain}")
    (lib.cmakeFeature "X86_DEV_ROOTFS" "${devRootFS}")
  ];

  strictDeps = true;

  # Unsupported on non-4K page size kernels (e.g. Apple Silicon)
  doCheck = true;

  nativeCheckInputs = [ nasm ];
  checkInputs = [ catch2_3 ];

  # List not exhaustive, e.g. because they depend on an x86 compiler or some
  # other difficult-to-build test binaries.
  checkTarget = lib.concatStringsSep " " [
    "asm_tests"
    "api_tests"
    "fexcore_apitests"
    "emitter_tests"
  ];

  # Avoid wrapping anything other than FEXConfig, since the wrapped executables
  # don't seem to work when registered as binfmts.
  dontWrapQtApps = true;
  preFixup = lib.optionalString withQt ''
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
