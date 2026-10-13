{
  lib,
  nix-update-script,
  stdenv,
  fetchFromGitHub,
  apple-sdk,
  cmake,
  coreutils,
  libxml2,
  openssl,
  pcre2,
  pony-corral,
  python3,
  zlib,
  git,
  replaceVars,
  which,
  z3,
  cctools,
  procps,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ponyc";
  version = "0.68.0";

  src = fetchFromGitHub {
    owner = "ponylang";
    repo = "ponyc";
    tag = finalAttrs.version;
    hash = "sha256-jydsirwU+O25+YgC0kDW7m30k9Opu+L/gG6Zr6vEcTk=";
    fetchSubmodules = true;
  };

  benchmarkRev = "1.9.5";
  benchmark = fetchFromGitHub {
    owner = "google";
    repo = "benchmark";
    rev = "v${finalAttrs.benchmarkRev}";
    hash = "sha256-Mm4pG7zMB00iof32CxreoNBFnduPZTMp3reHMCIAFPQ=";
  };

  googletestRev = "1.17.0";
  googletest = fetchFromGitHub {
    owner = "google";
    repo = "googletest";
    rev = "v${finalAttrs.googletestRev}";
    hash = "sha256-HIHMxAUR4bjmFLoltJeIAVSulVQ6kVuIT2Ku+lwAx/4=";
  };

  nativeBuildInputs = [
    cmake
    which
    python3
    git
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    cctools.libtool
  ];

  buildInputs = [
    libxml2
    openssl
    pcre2
    z3
    zlib
  ];

  patches = [
    ./cmake-presets.patch
    # Sandbox disallows network access, so disabling problematic networking tests
    ./disable-networking-tests.patch
    # Adds codegen/nix.cc + nix.h (the Nix toolchain-path helpers shared by the
    # embedded linker and C-shim compiler) and wires them into libponyc's
    # CMakeLists. Platform-independent, so applied verbatim everywhere.
    ./nix-codegen.patch
  ]
  ++ (
    let
      # These patch the embedded LLD/clang codegen and reference the macOS SDK
      # via @apple-sdk@; substitute it on Darwin, apply verbatim elsewhere (the
      # placeholder sits in macOS-only code that other platforms never compile).
      sdkPatches = [
        ./gencshim-pony-cc.patch
        ./genexe-pony-linker.patch
      ];
    in
    if stdenv.hostPlatform.isDarwin then
      map (p: replaceVars p { inherit apple-sdk; }) sdkPatches
    else
      sdkPatches
  );

  postUnpack = ''
    mkdir -p $NIX_BUILD_TOP/deps
    tar -C "$benchmark" -cf $NIX_BUILD_TOP/deps/benchmark-$benchmarkRev.tar .
    tar -C "$googletest" -cf $NIX_BUILD_TOP/deps/googletest-$googletestRev.tar .
  '';

  postPatch = ''
    substituteInPlace packages/process/_test.pony \
        --replace-fail '"/bin/' '"${coreutils}/bin/' \
        --replace-fail '=/bin' "${coreutils}/bin"
    substituteInPlace src/libponyc/pkg/package.c \
        --replace-fail "/usr/local/lib" "" \
        --replace-fail "/opt/local/lib" ""

    # Replace downloads with local copies.
    substituteInPlace lib/CMakeLists.txt \
        --replace-fail "https://github.com/google/benchmark/archive/v$benchmarkRev.tar.gz" "$NIX_BUILD_TOP/deps/benchmark-$benchmarkRev.tar" \
        --replace-fail "https://github.com/google/googletest/releases/download/v$googletestRev/googletest-$googletestRev.tar.gz" "$NIX_BUILD_TOP/deps/googletest-$googletestRev.tar"
  '';

  # We do not concern ourselves with darwin as the ponyc compiler
  # has logic which overrides this environment variable.
  env.arch =
    if stdenv.hostPlatform.isx86_64 then
      "x86-64"
    else if stdenv.hostPlatform.isAarch64 then
      "armv8-a"
    else
      lib.warn ''
        architecture '${stdenv.hostPlatform.system}' compiles with native optimizations,
        this may result in crashes on incompatible CPUs!
      '' "native";

  # Bake the Nix link/include paths into the compiler before it is built.
  preConfigure =
    lib.optionalString stdenv.hostPlatform.isLinux ''
      libcDir=$(dirname "$($CC -print-file-name=crt1.o)")
      gccDir=$(dirname "$($CC -print-libgcc-file-name)")
      gccSharedDir=$(dirname "$($CC -print-file-name=libgcc_s.so)")
      dynamicLinker=$(cat "$NIX_CC/nix-support/dynamic-linker")
      libcIncDir="$(cat "$NIX_CC/nix-support/orig-libc-dev")/include"
      # pcre2 and openssl are baked into the compiler's link path so an installed
      # ponyc can link `use "regex"` (pcre2) and `use "net/ssl"` (openssl)
      # programs without a wrapper — this replaces the old wrapProgram PONYPATH.
      export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -DPONY_NIX_LINK_LIBDIRS=\"$libcDir:$gccDir:$gccSharedDir:${lib.getLib pcre2}/lib:${lib.getLib openssl}/lib\" -DPONY_NIX_DYNAMIC_LINKER=\"$dynamicLinker\" -DPONY_NIX_INCLUDE_DIRS=\"$libcIncDir:$gccDir/include:$gccDir/include-fixed\""
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      # Bake pcre2/openssl into the compiler's link path so an installed ponyc can
      # link `use "regex"` / `use "net/ssl"` without a wrapper; libc and the C++
      # standard library come from the SDK (via xcrun / apple-sdk) at link time.
      export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -DPONY_NIX_LINK_LIBDIRS=\"${lib.getLib pcre2}/lib:${lib.getLib openssl}/lib\""
    '';

  # Upstream drives the build through CMakePresets (which fix the binaryDir and
  # compiler), so we bypass the cmake setup hook's configurePhase and invoke the
  # presets directly rather than fight its flags.
  configurePhase = ''
    runHook preConfigure
    cmake -DJOBS=$NIX_BUILD_CORES -P lib/build-libs.cmake
    cmake --preset release
    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild
    cmake --build --preset release --parallel $NIX_BUILD_CORES
    runHook postBuild
  '';

  env.NIX_CFLAGS_COMPILE = toString [
    "-Wno-error=redundant-move"
    "-Wno-error=implicit-fallthrough"
  ];

  doCheck = true;

  nativeCheckInputs = [ procps ];

  checkPhase = ''
    runHook preCheck
    ctest --preset release -L ci-core -j$NIX_BUILD_CORES
    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall
    cmake --install build/build_release --prefix=$out
    runHook postInstall
  '';

  # Stripping breaks linking for ponyc.
  dontStrip = true;

  passthru = {
    tests.pony-corral = pony-corral;
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Object-oriented, actor-model, capabilities-secure, high performance programming language";
    homepage = "https://www.ponylang.io";
    license = lib.licenses.bsd2;
    mainProgram = "ponyc";
    maintainers = with lib.maintainers; [
      kamilchm
      redvers
      numinit
    ];
    # Intel macOS (x86_64-darwin) is intentionally unsupported; only Apple
    # Silicon is supported on Darwin.
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
})
