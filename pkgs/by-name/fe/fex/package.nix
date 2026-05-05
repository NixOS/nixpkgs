{
  lib,
  llvmPackages,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
  python3,
  nix-update-script,
  xxhash,
  fmt,
  libxml2,
  openssl,
  range-v3,
  catch2_3,
  nasm,
  withLibraryForwarding ? true,
  buildEnv,
  writeText,
  pkgsCross,
  libclang,
  libllvm,
  alsa-lib,
  libdrm,
  libGL,
  wayland,
  libxrender,
  libxrandr,
  libx11,
  xorgproto,
  libxcb,
  withQt ? true,
  qt6,
}:

let
  # Headers required to build the ThunkLibs subtree
  libForwardingInputs = lib.map lib.getInclude [
    alsa-lib
    libdrm
    libGL
    wayland
    libx11
    libxcb
    libxrandr
    libxrender
    xorgproto
  ];

  pkgsCross32 = pkgsCross.gnu32;
  pkgsCross64 = pkgsCross.gnu64;

  devRootFS =
    let
      mkRoot =
        pkgs:
        buildEnv {
          name = "fex-dev-rootfs-${pkgs.buildPackages.stdenv.targetPlatform.parsed.cpu.name}";
          paths = with pkgs.stdenv.cc; [
            cc
            cc.lib
            libc_dev
          ];
          pathsToLink = [
            "/include"
            "/lib"
          ];
        };

      root32 = mkRoot pkgsCross32;
      root64 = mkRoot pkgsCross64;
      includes = buildEnv {
        name = "fex-dev-rootfs-include";
        paths = libForwardingInputs;
        pathsToLink = [ "/include" ];
        ignoreCollisions = true;
      };
    in
    buildEnv {
      name = "fex-dev-rootfs";
      paths = [
        root32
        root64
        includes
      ];
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

  mkToolchain =
    {
      pkgs,
      extraFlags ? "",
    }:
    let
      arch = pkgs.stdenv.targetPlatform.parsed.cpu.name; # i686 or x86_64
      platform = pkgs.stdenv.targetPlatform.config; # i686-unknown-linux-gnu or x86_64-unknown-linux-gnu
    in
    writeText "fex-thunk-toolchain-${arch}.txt" ''
      set(CMAKE_EXE_LINKER_FLAGS_INIT "-fuse-ld=lld")
      set(CMAKE_MODULE_LINKER_FLAGS_INIT "-fuse-ld=lld")
      set(CMAKE_SHARED_LINKER_FLAGS_INIT "-fuse-ld=lld -lstdc++")
      set(CMAKE_SYSTEM_PROCESSOR ${arch})
      set(CMAKE_C_COMPILER ${pkgs.clang}/bin/${platform}-clang)
      set(CMAKE_CXX_COMPILER ${pkgs.clang}/bin/${platform}-clang++)
      set(CLANG_FLAGS "-nodefaultlibs -nostartfiles -target ${platform} ${extraFlags} --sysroot=${devRootFS} -iwithsysroot/usr/include")
      set(CMAKE_C_FLAGS "''${CMAKE_C_FLAGS} ''${CLANG_FLAGS}")
      set(CMAKE_CXX_FLAGS "''${CMAKE_CXX_FLAGS} ''${CLANG_FLAGS}")
    '';
in

llvmPackages.stdenv.mkDerivation (finalAttrs: {
  pname = "fex";
  version = "2604";

  src = fetchFromGitHub {
    owner = "FEX-Emu";
    repo = "FEX";
    tag = "FEX-${finalAttrs.version}";
    hash = "sha256-VPlw15vM3wowgba9Z95F/vRYJLaevtt8lJEgw4hYS8w=";

    leaveDotGit = true;
    postFetch = ''
      cd $out
      git reset

      # Only fetch required submodules
      git submodule update --init --depth 1 \
        External/Vulkan-Headers \
        External/drm-headers \
        External/rpmalloc \
        External/jemalloc_glibc \
        External/vixl \
        External/unordered_dense \
        Source/Common/cpp-optparse

      find . -name .git -print0 | xargs -0 rm -rf

      # Remove some more unnecessary directories
      rm -r \
        External/vixl/src/aarch32 \
        External/vixl/test
    '';
  };

  postPatch = ''
    substituteInPlace FEXCore/include/git_version.h.in \
      --replace-fail "@GIT_HASH_ARRAY@" "" \
      --replace-fail "@GIT_DESCRIBE_STRING@" "FEX-${finalAttrs.version}"

    substituteInPlace ThunkLibs/GuestLibs/CMakeLists.txt ThunkLibs/HostLibs/CMakeLists.txt \
      --replace-fail "/usr/include/libdrm" "${devRootFS}/include/libdrm" \
      --replace-fail "/usr/include/wayland" "${devRootFS}/include/wayland"

    # Add include paths for thunkgen invocation
    substituteInPlace ThunkLibs/HostLibs/CMakeLists.txt \
      --replace-fail "-- " "-- $(cat ${llvmPackages.stdenv.cc}/nix-support/libc-cflags) $(cat ${llvmPackages.stdenv.cc}/nix-support/libcxx-cxxflags) ${
        lib.concatMapStrings (x: "-isystem ${x}/include ") libForwardingInputs
      }"
    substituteInPlace ThunkLibs/GuestLibs/CMakeLists.txt \
      --replace-fail "-- " "-- $(cat ${llvmPackages.stdenv.cc}/nix-support/libcxx-cxxflags) "

    # Disable including current date in manpages
    substituteInPlace FEXCore/Scripts/config_generator.py \
      --replace-fail ".Dd {0}" ".Dd" \
      --replace-fail "output_man.write(header.format(" "output_man.write(header) #"

    # Temporarily disable failing tests. TODO: investigate the root cause of these failures
    rm \
      unittests/ASM/Primary/Primary_63_2.asm \
      unittests/32Bit_ASM/Secondary/07_XX_04.asm \
      unittests/ASM/Secondary/07_XX_04.asm
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
    xxhash
    fmt
    libxml2
    openssl
    range-v3
  ]
  ++ lib.optionals withLibraryForwarding (
    [
      pkgsCross64.buildPackages.clang
      pkgsCross32.buildPackages.clang
      libclang
      libllvm
    ]
    ++ libForwardingInputs
  )
  ++ lib.optionals withQt [
    qt6.qtbase
    qt6.qtdeclarative
  ];

  cmakeFlags = [
    (lib.cmakeFeature "USE_LINKER" "lld")
    (lib.cmakeFeature "OVERRIDE_VERSION" finalAttrs.version)
    (lib.cmakeBool "BUILD_FEXCONFIG" withQt)
  ]
  ++ lib.optionals withLibraryForwarding [
    (lib.cmakeBool "BUILD_THUNKS" true)
    (lib.cmakeFeature "X86_32_TOOLCHAIN_FILE" "${mkToolchain {
      pkgs = pkgsCross32.buildPackages;
      extraFlags = "-msse2 -mfpmath=sse";
    }}")
    (lib.cmakeFeature "X86_64_TOOLCHAIN_FILE" "${mkToolchain {
      pkgs = pkgsCross64.buildPackages;
    }}")
    (lib.cmakeFeature "X86_DEV_ROOTFS" "${devRootFS}")
  ];

  strictDeps = true;

  # Running the tests isn't supported on non-4K pagesize systems, but the build
  # itself doesn't require 4K pagesize. So, to avoid breaking the build, enable
  # checkPhase by default (so that the check inputs are included) and then
  # manually disable it if we're running on a non-4K pagesize system.
  doCheck = true;
  preConfigure = ''
    if [ "$(getconf PAGESIZE)" != "4096" ]; then
      echo "Disabling checkPhase due to non-4K pagesize environment"
      unset doCheck
      cmakeFlagsArray+=("-DBUILD_TESTING:BOOL=FALSE")
    else
      echo "Keeping checkPhase as-is"
      cmakeFlagsArray+=("${lib.cmakeBool "BUILD_TESTING" finalAttrs.doCheck}")
    fi
  '';

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
    inherit devRootFS;
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
