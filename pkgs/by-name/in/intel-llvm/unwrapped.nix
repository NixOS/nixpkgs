{
  # Parameters for overriding
  src,
  version,
  commitDate,
  llvmMajorVersion,
  vc-intrinsics-src,
  make-unified-runtime,
  # Regular dependencies
  lib,
  stdenv,
  cmake,
  ninja,
  fetchpatch,
  python3,
  pkg-config,
  zstd,
  hwloc,
  emhash,
  level-zero,
  opencl-headers,
  libxml2,
  libedit,
  llvmPackages_22,
  parallel-hashmap,
  spirv-headers,
  spirv-tools,
  zlib,
  wrapCC,
  graphviz-nox,
  rocmPackages ? { },
  rocmGpuTargets ? lib.optionalString (rocmPackages ? clr.gpuTargets) (
    builtins.concatStringsSep ";" rocmPackages.clr.gpuTargets
  ),
  config,
  cudaSupport ? config.cudaSupport,
  rocmSupport ? config.rocmSupport,
  # TODO: Should there be a flag like config.levelZeroSupport?
  # NOTE: Level Zero does not always fail gracefully, so when not explicitly set by the user,
  #       and other acceleration is already selected, disable it by default.
  levelZeroSupport ? !(cudaSupport || rocmSupport),
  nativeCpuSupport ? true,
  enableManpages ? true,
}:
let
  # See the postPatch phase for details on why this is used
  ccWrapperStub = wrapCC (
    stdenv.mkDerivation {
      name = "ccWrapperStub";
      dontUnpack = true;
      installPhase = ''
        mkdir -p $out/bin
        cat > $out/bin/clang-${llvmMajorVersion} <<'EOF'
        #!/bin/sh
        exec "$NIX_BUILD_TOP/source/build/bin/clang-${llvmMajorVersion}" "$@"
        EOF
        chmod +x $out/bin/clang-${llvmMajorVersion}
        cp $out/bin/clang-${llvmMajorVersion} $out/bin/clang
        cp $out/bin/clang-${llvmMajorVersion} $out/bin/clang++
      '';
      passthru = {
        isClang = true;
        langC = true;
        langCC = true;

        # cc-wrapper adds `-nostdlibinc` to every Linux clang, which makes the SYCL driver
        # skip its `stl_wrappers` include dir, caysubg libdevice compiles then fail with
        # `'__spirv_BuiltIn...' undeclared`. `isROCm` is cc-wrapper's only opt-out
        # from that flag and is read nowhere else.
        # The name is a poor fit, but it does exactly what we want.
        isROCm = true;
      };
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
  unified-runtime = make-unified-runtime {
    inherit
      levelZeroSupport
      cudaSupport
      rocmSupport
      rocmGpuTargets
      nativeCpuSupport
      ;
  };
in
# Tip: This build plays nice with ccacheStdenv.
#      Replace stdenv here to make debugging less tedious.
stdenv.mkDerivation (finalAttrs: {
  pname = "intel-llvm";

  inherit src version commitDate;

  outputs = [
    "out"
    "lib"
    "dev"
    "python"
    # Not adding (conditionally) a "man" output here to avoid complexity in the
    # wrapper, that is not worth it for a few kb.
  ];

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    cmake
    ninja
    python3
    llvmPackages_22.bintools # For lld
    pkg-config
    zlib
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
    # Static ZSTD is required by sycl, see sycl/source/CMakeLists.txt:163
    # Intels CMake/build system also enabled `LLVM_USE_STATIC_ZSTD` by default,
    # so at no point does it link to a non-static ZSTD library.
    # This may be related to the fork not supporting building shared libraries;
    #  https://github.com/intel/llvm/issues/19060
    (zstd.override { static = true; })
  ]
  ++ unified-runtime.buildInputs;

  propagatedBuildInputs = [
    zlib
    libedit
    opencl-headers
  ];

  cmakeBuildType = "Release";
  # This is to shave a little bit of size off of the final NAR.
  # Saves about 0.5GiB
  # Note that the sum of all outputs needs to stay under 4GiB to be cached by Hydra.
  # To check:
  #  nix path-info --json --json-format 2 .#intel-llvm.unwrapped{,.lib,.dev,.python} | jq '[.. | .narSize? // empty] | add'
  stripDebugFlags = [ "--strip-unneeded" ];

  patches = [
    # Fix paths so the output can be split properly
    ./gnu-install-dirs.patch
    # sycl-jit bundles several files, among which are CMake files.
    # The CMake files are bundled, yet not actually used.
    # As the CMake files in question contain absolute install paths,
    # they cause cycles in the outputs and break the build,
    # so we simply exclude them.
    ./sycl-jit-exclude-cmake-files.patch

    # Linux removed `linux/scc.h`, which breaks building compiler-rt. Upstream LLVM has fixed it in LLVM 22 and 23.
    # The same patch is applied in d5b6cbf (llvmPackages_{18,19,20,21}.compiler-rt: backport santizier fix for Linux)
    (fetchpatch {
      url = "https://github.com/llvm/llvm-project/commit/3dc4fd6dd41100f051a63642f449b16324389c96.patch?full_index=1";
      hash = "sha256-BJwFPeYCBO+PnUMMC/3GSYPgn0vczkkbdw5qcnURPbI=";
    })
  ];

  postPatch = ''
    # Parts of libdevice are built using the freshly-built compiler.
    # As it tries to link to system libraries, we need to wrap it with the
    # usual nix cc-wrapper.
    # Since the compiler to be wrapped is not available at this point,
    # we use a stub that points to where it will be later on
    # in `$NIX_BUILD_TOP/source/build/bin/clang-${llvmMajorVersion}`
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
  ''
  # v7.0.0 half-applied an upstream rename of libclc's AMD target. Without this patch,
  # The compiler builds and links fully, but the final compiler will lack the device libraries
  # needed for compilating to AMD.
  # Build `pkgsRocm.intel-llvm.tests.sycl-compile-amdgcn-amd-amdhsa` to check; it fails without this patch.
  # TODO: It's likely that we can drop this on the next update.
  + lib.optionalString rocmSupport ''
    substituteInPlace libclc/CMakeLists.txt \
      --replace-fail $'  amdgcn-amd-amdhsa\n' $'  amdgcn-amd-amdhsa\n  amdgcn--amdhsa\n' \
      --replace-fail 'set( amdgcn-amd-amdhsa_devices none )' \
        $'set( amdgcn-amd-amdhsa_devices none )\nset( amdgcn--amdhsa_devices none )'
  ''
  # These libdevice compiles target sm_75 (since v7.0.0), which needs PTX >= 6.3.
  # clang picks the PTX ISA from the CUDA version it detects, if it detects nothing it falls back to `+ptx42`.
  # `-nocudalib` only skips linking libdevice.bc, not detection, so point --cuda-path
  # at the toolkit to get a real version and a modern PTX ISA.
  + lib.optionalString cudaSupport ''
    substituteInPlace libdevice/cmake/modules/SYCLLibdevice.cmake \
      --replace-fail '"--cuda-gpu-arch=sm_75" "-nocudalib"' \
      '"--cuda-gpu-arch=sm_75" "-nocudalib" "--cuda-path=${unified-runtime.setupVars.CUDA_PATH}"'
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
    (lib.cmakeFeature "LLVM_ENABLE_ZLIB" "FORCE_ON")
    (lib.cmakeBool "LLVM_ENABLE_THREADS" true)

    # Link with lld. Not buildbot's `--use-lld` (LLVM_ENABLE_LLD=ON): xpti/xptifw
    # re-`include(HandleLLVMOptions)`, which derives LLVM_USE_LINKER from it and then
    # aborts on "LLVM_ENABLE_LLD and LLVM_USE_LINKER can't be set at the same time".
    (lib.cmakeFeature "LLVM_USE_LINKER" "lld")

    # Intels LLVM fork does not support building shared libraries,
    # see https://github.com/intel/llvm/issues/19060
    (lib.cmakeBool "BUILD_SHARED_LIBS" false)
    (lib.cmakeBool "LLVM_LINK_LLVM_DYLIB" false)
    (lib.cmakeBool "LLVM_BUILD_LLVM_DYLIB" false)

    # See https://github.com/intel/llvm/issues/19692
    (lib.cmakeFeature "SYCL_COMPILER_VERSION" commitDate)

    (lib.cmakeBool "FETCHCONTENT_FULLY_DISCONNECTED" true)
    (lib.cmakeBool "FETCHCONTENT_QUIET" false)

    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_VC-INTRINSICS" "${vc-intrinsics-src}")
    (lib.cmakeFeature "LLVM_EXTERNAL_SPIRV_HEADERS_SOURCE_DIR" "${spirv-headers.src}")

    # Ideally, we'd set this to "${placeholder "lib"}/lib/clang/${clangMajorVersion}",
    # however this breaks the libdevice build.
    # Instead, we just deal with it in postInstall
    (lib.cmakeFeature "CLANG_RESOURCE_DIR" "../lib/clang/${llvmMajorVersion}")
    (lib.cmakeFeature "LLVM_INSTALL_PACKAGE_DIR" "${placeholder "dev"}/lib/cmake/llvm")

    (lib.cmakeBool "LLVM_INCLUDE_DOCS" enableManpages)
    (lib.cmakeBool "MLIR_INCLUDE_DOCS" enableManpages)
    (lib.cmakeBool "LLVM_BUILD_DOCS" enableManpages)
    (lib.cmakeBool "LLVM_ENABLE_SPHINX" enableManpages)
    (lib.cmakeBool "SPHINX_OUTPUT_MAN" enableManpages)

    # The buildbot script always enables level-zero no matter what.
    # To allow disabling level-zero, we override its flag here,
    # so it gets excluded when not enabled.
    (lib.cmakeFeature "SYCL_ENABLE_BACKENDS" (
      lib.strings.concatStringsSep ";" unified-runtime.backends
    ))
  ]
  ++ unified-runtime.cmakeFlags;

  # This hardening option causes compilation errors when compiling for amdgcn, spirv and others
  # Must be disabled during intel-llvm's own build (especially for libdevice)
  hardeningDisable = [ "zerocallusedregs" ];

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

    # As explained above, this lands in $out, but we want it in $lib and we need to fix it by hand.
    moveToOutput "lib/clang/${llvmMajorVersion}" "$lib"
    substituteInPlace "$dev/include/clang/Config/config.h" \
      --replace-fail "../lib/clang/${llvmMajorVersion}" "$lib/lib/clang/${llvmMajorVersion}"
  '';

  passthru = {
    isClang = true;
    langC = true;
    langCC = true;

    inherit unified-runtime;

    # This is for easily referencing version-compatible LLVM libraries
    # and tools that aren't built in this derivation,
    # as well as nix tooling, such as the stdenv.
    baseLlvm = llvmPackages_22;

    inherit llvmMajorVersion;

    # This hardening option causes compilation errors when compiling for amdgcn, spirv and others
    hardeningUnsupportedFlags = [ "zerocallusedregs" ];
  };

  meta = {
    description = "Intel LLVM-based compiler with SYCL support";
    longDescription = ''
      Intel's LLVM-based compiler toolchain with Data Parallel C++ (DPC++)
      and SYCL support for heterogeneous computing across CPUs, GPUs, and FPGAs.
    '';
    homepage = "https://github.com/intel/llvm";
    mainProgram = "clang";
    license = with lib.licenses; [
      ncsa
      asl20
      llvm-exception
    ];
    maintainers = with lib.maintainers; [ kilyanni ];
    platforms = [ "x86_64-linux" ];
  };
})
