{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  python3,
  pkg-config,
  zstd,
  pkgsStatic,
  hwloc,
  emhash,
  level-zero,
  opencl-headers,
  libxml2,
  libedit,
  llvmPackages,
  # Ideally this would be the LLVM with the same major version
  # as the LLVM built here (22). However LLVM 22 is packaged
  # as the alias llvmPackages_git and not available
  # for use as a dependency.
  llvmPackages_21,
  callPackage,
  parallel-hashmap,
  spirv-headers,
  spirv-tools,
  zlib,
  wrapCC,
  graphviz-nox,
  nix-update-script,
  rocmPackages ? { },
  rocmGpuTargets ? lib.optionalString (rocmPackages != { }) (
    builtins.concatStringsSep ";" rocmPackages.clr.gpuTargets
  ),
  config,
  # TODO: Should there be a flag like config.levelZeroSupport?
  levelZeroSupport ? true,
  # The cudaSupport flag currently just sets this package to broken,
  # as CUDA support is currently not implemented in this derivation.
  # Upstream supports CUDA, so if a user of the derivation were to use this package
  # with cudaSupport = true, they would not get the expected behavior.
  cudaSupport ? config.cudaSupport,
  rocmSupport ? config.rocmSupport,
  nativeCpuSupport ? true,
  enableManpages ? true,
}:
let
  version = "unstable-2025-11-14";
  date = "20251114";
  src = fetchFromGitHub {
    owner = "intel";
    repo = "llvm";
    # Latest commit which doesn't require dependency versions newer than
    # what's available in nixpkgs as of 2025-12-11.
    # Commits after require newer level-zero and pre-release unified memory framework.
    rev = "ab3dc98de0fd1ada9df12b138de1e1f8b715cc27";
    hash = "sha256-oHk8kQVNsyC9vrOsDqVoFLYl2yMMaTgpQnAW9iHZLfE=";
  };
  vc-intrinsics = fetchFromGitHub {
    owner = "intel";
    repo = "vc-intrinsics";
    # See llvm/lib/SYCLLowerIR/CMakeLists.txt:17
    rev = "60cea7590bd022d95f5cf336ee765033bd114d69";
    sha256 = "sha256-1K16UEa6DHoP2ukSx58OXJdtDWyUyHkq5Gd2DUj1644=";
  };
  # See the postPatch phase for details on why this is used
  ccWrapperStub = wrapCC (
    stdenv.mkDerivation {
      name = "ccWrapperStub";
      dontUnpack = true;
      installPhase = ''
        mkdir -p $out/bin
        cat > $out/bin/clang-22 <<'EOF'
        #!/bin/sh
        exec "$NIX_BUILD_TOP/source/build/bin/clang-22" "$@"
        EOF
        chmod +x $out/bin/clang-22
        cp $out/bin/clang-22 $out/bin/clang
        cp $out/bin/clang-22 $out/bin/clang++
      '';
      passthru.isClang = true;
    }
  );
  # We use the in-tree unified-runtime, but we need all the same flags as the out-of-tree version.
  # Rather than duplicating the flags, we import them from unified-runtime.nix.
  #
  # This also lets us quickly test unified-runtime in isolation for debugging backend issues.
  # If the build LLVM fails due to issues with finding level-zero/ROCm/etc.,
  # it's a lot quicker to just rebuild unified-runtime instead of all of LLVM.
  #
  # As unified-runtime is the interface between LLVM and the backends,
  # that is where most failures relating to backends should happen in.
  unified-runtime = callPackage ./unified-runtime.nix {
    intel-llvm-src = src;
    inherit
      levelZeroSupport
      cudaSupport
      rocmSupport
      rocmGpuTargets
      nativeCpuSupport
      ;
    # This could theoretically be disabled if you for some reason
    # didn't want to build the backend, however OpenCL will get
    # pulled in as a dependency either way so there is little point.
    openclSupport = true;
  };
in
# Tip: This build plays nice with ccacheStdenv.
#      Replace stdenv here to make debugging less tedious.
stdenv.mkDerivation (finalAttrs: {
  pname = "intel-llvm";
  inherit version src;

  outputs = [
    "out"
    "lib"
    "dev"
    "python"
  ];

  nativeBuildInputs = [
    cmake
    ninja
    python3
    llvmPackages.bintools # For lld
    pkg-config
    zlib
    zstd
  ]
  ++ lib.optionals enableManpages [
    python3.pkgs.sphinx
    python3.pkgs.myst-parser
    graphviz-nox
  ];

  buildInputs = [
    spirv-tools
    libxml2
    hwloc
    emhash
    parallel-hashmap
    pkgsStatic.zstd
  ]
  ++ unified-runtime.buildInputs;

  propagatedBuildInputs = [
    zstd
    zlib
    libedit
    opencl-headers
  ];

  cmakeBuildType = "Release";

  patches = [
    # Fix paths so the output can be split properly
    ./gnu-install-dirs.patch
    # sycl-jit bundles several files, among which are CMake files.
    # The CMake files are bundled, yet not actually used.
    # As the CMake files in question contain absolute install paths,
    # they cause cycles in the outputs and break the build,
    # so we simply exclude them.
    ./sycl-jit-exclude-cmake-files.patch
  ];

  postPatch = ''
    # Parts of libdevice are built using the freshly-built compiler.
    # As it tries to link to system libraries, we need to wrap it with the
    # usual nix cc-wrapper.
    # Since the compiler to be wrapped is not available at this point,
    # we use a stub that points to where it will be later on
    # in `$NIX_BUILD_TOP/source/build/bin/clang-22`
    substituteInPlace libdevice/cmake/modules/SYCLLibdevice.cmake \
      --replace-fail "\''${clang_exe}" "${ccWrapperStub}/bin/clang++"

    # When running without this, their CMake code copies files from the Nix store.
    # As the Nix store is read-only and COPY copies permissions by default,
    # this will lead to the copied files also being read-only.
    # As CMake at a later point wants to write into copied folders, this causes
    # the build to fail with a (rather cryptic) permission error.
    # By setting NO_SOURCE_PERMISSIONS we side-step this issue.
    # Note in case of future build failures: if there are executables in any of the copied folders,
    # we may need to add special handling to set the executable permissions.
    # See also: https://github.com/intel/llvm/issues/19635#issuecomment-3134830708
    sed -i '/file(COPY / { /NO_SOURCE_PERMISSIONS/! s/)\s*$/ NO_SOURCE_PERMISSIONS)/ }' \
      unified-runtime/cmake/FetchLevelZero.cmake \
      sycl/CMakeLists.txt \
      sycl/cmake/modules/FetchEmhash.cmake

    # `NO_CMAKE_PACKAGE_REGISTRY` prevents it from finding OpenCL, so we unset it
    # Note that this cmake file is imported in various places, not just unified-runtime
    # See also: https://github.com/intel/llvm/issues/19635#issuecomment-3247008981
    substituteInPlace unified-runtime/cmake/FetchOpenCL.cmake \
        --replace-fail "NO_CMAKE_PACKAGE_REGISTRY" ""
  '';

  preConfigure = ''
    flags=$(python buildbot/configure.py \
        --print-cmake-flags \
        -t Release \
        --docs \
        --cmake-gen Ninja \
        ${lib.optionalString cudaSupport "--cuda"} \
        ${lib.optionalString rocmSupport "--hip"} \
        ${lib.optionalString nativeCpuSupport "--native_cpu"} \
        --use-lld \
        ${lib.optionalString levelZeroSupport "--l0-headers ${lib.getInclude level-zero}/include/level_zero"} \
        ${lib.optionalString levelZeroSupport "--l0-loader ${lib.getLib level-zero}/lib/libze_loader.so"} \
    )

    # We eval because flags is separated as shell-escaped strings.
    # We can't just split by space because it may contain escaped spaces,
    # so we just let bash handle it.
    # NOTE: We prepend, so that flags we set manually override what the build script does.
    eval "prependToVar cmakeFlags $flags"

    # Remove the install prefix flag
    cmakeFlags=(''${cmakeFlags[@]/-DCMAKE_INSTALL_PREFIX=$NIX_BUILD_TOP\/source\/build\/install})
  '';

  cmakeDir = "llvm";

  cmakeFlags = [
    (lib.cmakeBool "LLVM_INSTALL_UTILS" true)

    (lib.cmakeBool "LLVM_BUILD_TESTS" false)
    (lib.cmakeBool "LLVM_INCLUDE_TESTS" false)
    (lib.cmakeBool "MLIR_INCLUDE_TESTS" false)
    (lib.cmakeBool "SYCL_INCLUDE_TESTS" false)

    (lib.cmakeFeature "LLVM_ENABLE_ZSTD" "FORCE_ON")
    (lib.cmakeBool "LLVM_USE_STATIC_ZSTD" true)
    (lib.cmakeFeature "LLVM_ENABLE_ZLIB" "FORCE_ON")
    (lib.cmakeBool "LLVM_ENABLE_THREADS" true)

    # Having these set to true breaks the build
    # See https://github.com/intel/llvm/issues/19060
    (lib.cmakeBool "BUILD_SHARED_LIBS" false)
    (lib.cmakeBool "LLVM_LINK_LLVM_DYLIB" false)
    (lib.cmakeBool "LLVM_BUILD_LLVM_DYLIB" false)

    # See https://github.com/intel/llvm/issues/19692
    (lib.cmakeFeature "SYCL_COMPILER_VERSION" date)

    (lib.cmakeBool "FETCHCONTENT_FULLY_DISCONNECTED" true)
    (lib.cmakeBool "FETCHCONTENT_QUIET" false)

    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_VC-INTRINSICS" "${vc-intrinsics}")
    (lib.cmakeFeature "LLVM_EXTERNAL_SPIRV_HEADERS_SOURCE_DIR" "${spirv-headers.src}")

    (lib.cmakeFeature "CLANG_RESOURCE_DIR" "lib/clang/22")
    (lib.cmakeFeature "LLVM_INSTALL_PACKAGE_DIR" "${placeholder "dev"}/lib/cmake/llvm")

    (lib.cmakeBool "LLVM_INCLUDE_DOCS" enableManpages)
    (lib.cmakeBool "MLIR_INCLUDE_DOCS" enableManpages)
    (lib.cmakeBool "LLVM_BUILD_DOCS" enableManpages)
    (lib.cmakeBool "LLVM_ENABLE_SPHINX" enableManpages)
    (lib.cmakeBool "SPHINX_OUTPUT_MAN" enableManpages)
  ]
  ++ unified-runtime.cmakeFlags;

  # This hardening option causes compilation errors when compiling for amdgcn, spirv and others
  # Must be disabled during intel-llvm's own build (especially for libdevice)
  hardeningDisable = [ "zerocallusedregs" ];

  # Without this it fails to link to hwloc, despite it being in the buildInputs
  NIX_LDFLAGS = "-lhwloc";

  requiredSystemFeatures = [ "big-parallel" ];
  enableParallelBuilding = true;

  # The vast majority of tests work, however many of the more relevant
  # ones struggle due to the lack of wrapping, causing it to
  # not discover the standard library.
  # If the wrapper is used instead however, other tests will fail
  # that test CLI edge cases, and with the wrapper,
  # those will differ compared to the vanilla build,
  # making the tests fail.
  doCheck = false;

  # Copied from the regular LLVM derivation:
  #  pkgs/development/compilers/llvm/common/llvm/default.nix
  postInstall = ''
    mkdir -p $python/share
    mv $out/share/opt-viewer $python/share/opt-viewer

    # If this stays in $out/bin, it'll create a circular reference
    moveToOutput "bin/llvm-config*" "$dev"

    substituteInPlace "$dev/lib/cmake/llvm/LLVMExports-${lib.toLower finalAttrs.finalPackage.cmakeBuildType}.cmake" \
      --replace-fail "$out/bin/llvm-config" "$dev/bin/llvm-config"
    substituteInPlace "$dev/lib/cmake/llvm/LLVMConfig.cmake" \
      --replace-fail 'set(LLVM_BINARY_DIR "''${LLVM_INSTALL_PREFIX}")' 'set(LLVM_BINARY_DIR "'"$lib"'")'
  '';

  meta = with lib; {
    description = "Intel LLVM-based compiler with SYCL support";
    longDescription = ''
      Intel's LLVM-based compiler toolchain with Data Parallel C++ (DPC++)
      and SYCL support for heterogeneous computing across CPUs, GPUs, and FPGAs.
    '';
    homepage = "https://github.com/intel/llvm";
    license = with licenses; [
      ncsa
      asl20
      llvm-exception
    ];
    maintainers = with maintainers; [ blenderfreaky ];
    broken = cudaSupport;
    platforms = [ "x86_64-linux" ];
  };

  passthru = {
    isClang = true;

    inherit unified-runtime;

    # This is for easily referencing version-compatible LLVM libraries
    # and tools that aren't built in this derivation,
    # as well as nix tooling, such as the stdenv.
    # As above, ideally this would be LLVM 22, but for now, we use LLVM 21.
    baseLlvm = llvmPackages_21;

    updateScript = nix-update-script { };

    # This hardening option causes compilation errors when compiling for amdgcn, spirv and others
    hardeningUnsupportedFlags = [ "zerocallusedregs" ];
  };
})
