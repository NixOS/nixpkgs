{
  lib,
  stdenv,
  llvm_meta,
  monorepoSrc,
  runCommand,
  cmake,
  ninja,
  libxml2,
  libllvm,
  version,
  python3,
  tblgen,
  replaceVars,
  fetchpatch,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "clang";
  inherit version;

  src = runCommand "clang-src-${version}" { inherit (monorepoSrc) passthru; } ''
    mkdir -p "$out"
    cp -r ${monorepoSrc}/cmake "$out"
    cp -r ${monorepoSrc}/clang "$out"
    cp -r ${monorepoSrc}/clang-tools-extra "$out"
  '';

  sourceRoot = "${finalAttrs.src.name}/clang";

  patches = [
    ./purity.patch
    # Remove extraneous ".a" suffix from baremetal clang_rt.builtins when compiling for baremetal.
    # https://reviews.llvm.org/D51899
    ./gnu-install-dirs.patch

    # https://github.com/llvm/llvm-project/pull/116476
    # prevent clang ignoring warnings / errors for unsuppored
    # options when building & linking a source file with trailing
    # libraries. eg: `clang -munsupported hello.c -lc`
    ./clang-unsupported-option.patch
    (fetchpatch {
      name = "ignore-nostd-link.patch";
      url = "https://github.com/llvm/llvm-project/commit/5b77e752dcd073846b89559d6c0e1a7699e58615.patch";
      relative = "clang";
      hash = "sha256-qzSAmoGY+7POkDhcGgQRPaNQ3+7PIcIc9cZuiE/eLkc=";
    })
    # Pass the correct path to libllvm
    (replaceVars (./clang-11-15-LLVMgold-path.patch) {
      libllvmLibdir = "${libllvm.lib}/lib";
    })

    # Backport version logic from Clang 16. This is needed by the following patch.
    (fetchpatch {
      name = "clang-darwin-Use-consistent-version-define-stringifying-logic.patch";
      url = "https://github.com/llvm/llvm-project/commit/60a33ded751c86fff9ac1c4bdd2b341fbe4b0649.patch?full_index=1";
      includes = [ "lib/Basic/Targets/OSTargets.cpp" ];
      stripLen = 1;
      hash = "sha256-YVTSg5eZLz3po2AUczPNXCK26JA3CuTh6Iqp7hAAKIs=";
    })
    # Backport `__ENVIRONMENT_OS_VERSION_MIN_REQUIRED__` support from Clang 17.
    # This is needed by newer SDKs (14+).
    (fetchpatch {
      name = "clang-darwin-An-OS-version-preprocessor-define.patch";
      url = "https://github.com/llvm/llvm-project/commit/c8e2dd8c6f490b68e41fe663b44535a8a21dfeab.patch?full_index=1";
      includes = [ "lib/Basic/Targets/OSTargets.cpp" ];
      stripLen = 1;
      hash = "sha256-Vs32kql7N6qtLqc12FtZHURcbenA7+N3E/nRRX3jdig=";
    })
  ];

  nativeBuildInputs = [
    cmake
    python3
    ninja
  ];

  buildInputs = [
    libxml2
    libllvm
  ];

  cmakeFlags = [
    (lib.cmakeFeature "CLANG_INSTALL_PACKAGE_DIR" "${placeholder "dev"}/lib/cmake/clang")
    (lib.cmakeBool "CLANGD_BUILD_XPC" false)
    (lib.cmakeBool "LLVM_ENABLE_RTTI" true)
    (lib.cmakeFeature "LLVM_TABLEGEN_EXE" "${tblgen}/bin/llvm-tblgen")
    (lib.cmakeFeature "CLANG_TABLEGEN" "${tblgen}/bin/clang-tblgen")
    (lib.cmakeFeature "CLANG_TIDY_CONFUSABLE_CHARS_GEN" "${tblgen}/bin/clang-tidy-confusable-chars-gen")
    (lib.cmakeFeature "CLANG_PSEUDO_GEN" "${tblgen}/bin/clang-pseudo-gen")
  ];

  postPatch = ''
    # Make sure clang passes the correct location of libLTO to ld64
    substituteInPlace lib/Driver/ToolChains/Darwin.cpp \
      --replace-fail 'StringRef P = llvm::sys::path::parent_path(D.Dir);' 'StringRef P = "${lib.getLib libllvm}";'
    (cd tools && ln -s ../../clang-tools-extra extra)
  '';

  outputs = [
    "out"
    "lib"
    "dev"
    "python"
  ];

  separateDebugInfo = stdenv.buildPlatform.is64bit; # OOMs on 32 bit

  postInstall = ''
    ln -sv $out/bin/clang $out/bin/cpp

    # Move libclang to 'lib' output
    moveToOutput "lib/libclang.*" "$lib"
    moveToOutput "lib/libclang-cpp.*" "$lib"
    mkdir -p $python/bin $python/share/clang/
    mv $out/bin/{git-clang-format,scan-view} $python/bin
    if [ -e $out/bin/set-xcode-analyzer ]; then
      mv $out/bin/set-xcode-analyzer $python/bin
    fi
    mv $out/share/clang/*.py $python/share/clang
    rm $out/bin/c-index-test
    patchShebangs $python/bin

    mkdir -p $dev/bin
    cp bin/{clang-tblgen,clang-tidy-confusable-chars-gen,clang-pseudo-gen} $dev/bin
  '';

  env =
    lib.optionalAttrs (stdenv.buildPlatform != stdenv.hostPlatform && !stdenv.hostPlatform.useLLVM)
      {
        # The following warning is triggered with (at least) gcc >=
        # 12, but appears to occur only for cross compiles.
        NIX_CFLAGS_COMPILE = "-Wno-maybe-uninitialized";
      };

  passthru = {
    isClang = true;
    hardeningUnsupportedFlagsByTargetPlatform = _: [
      "fortify3"
      "pacret"
      "strictflexarrays3"
    ];
  };

  requiredSystemFeatures = [ "big-parallel" ];
  meta = llvm_meta // {
    homepage = "https://clang.llvm.org/";
    description = "C language family frontend for LLVM";
    longDescription = ''
      The Clang project provides a language front-end and tooling
      infrastructure for languages in the C language family (C, C++, Objective
      C/C++, OpenCL, CUDA, and RenderScript) for the LLVM project.
      It aims to deliver amazingly fast compiles, extremely useful error and
      warning messages and to provide a platform for building great source
      level tools. The Clang Static Analyzer and clang-tidy are tools that
      automatically find bugs in your code, and are great examples of the sort
      of tools that can be built using the Clang frontend as a library to
      parse C/C++ code.
    '';
    mainProgram = "clang";
  };
})
