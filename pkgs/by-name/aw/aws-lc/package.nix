{
  lib,
  stdenv,
  fetchFromGitHub,
  buildGoModule,
  cmake,
  ninja,
  go,
  perl,
  rust-bindgen,
  versionCheckHook,
  testers,
  nix-update-script,
  aws-lc,
  writableTmpDirAsHomeHook,
  runCommand,
  enableTests ? true,
  useSharedLibraries ? !stdenv.hostPlatform.isStatic,
  withRustBindings ? true,
  symbolPrefix ? "AWS_LC",
  # This option might lead to OpenSSL being silently swapped to AWS-LC. Only use it if you know what you are doing.
  withOpenSSLShim ? false,
  # Testing
  pkgsStatic,
  pkgsCross,
}:

let
  aws-lc' = aws-lc.override {
    enableTests = false;
    useSharedLibraries = false;
    symbolPrefix = null;
  };
  symbols =
    runCommand "aws-lc-symbols"
      {
        inherit (aws-lc) src;
        nativeBuildInputs = [ writableTmpDirAsHomeHook ];
        # read_symbols.go runs on the build platform
        depsBuildBuild = [ go ];
      }
      ''
        cd "$src"
        go run ./util/read_symbols.go -out "$TMPDIR/symbols_crypto.txt" ${aws-lc'}/lib/libcrypto-awslc.a
        go run ./util/read_symbols.go -out "$TMPDIR/symbols_ssl.txt" ${aws-lc'}/lib/libssl-awslc.a
        cat "$TMPDIR"/symbols_{crypto,ssl}.txt > $out
      '';
in

stdenv.mkDerivation (finalAttrs: {
  pname = "aws-lc";
  version = "5.14.0";

  patches = [
    ./fix-dynamic-loading-test.patch
    ./fix-openssl-shim-symlinks.patch
  ];

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "aws";
    repo = "aws-lc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MJuQJv9iRuktxUQaIB6GfFeKbV6tWx0DhbmjR47TnK0=";
  };

  outputs = [
    "out"
    "bin"
    "dev"
  ];

  env.GOFLAGS = lib.optionalString stdenv.hostPlatform.isStatic "-ldflags=-linkmode=external";

  depsBuildBuild = [ go ];
  nativeBuildInputs = [
    writableTmpDirAsHomeHook
    cmake
    ninja
    perl
  ]
  ++ lib.optionals withRustBindings [
    rust-bindgen
  ];

  goDeps =
    (buildGoModule {
      inherit (finalAttrs) pname version src;
      vendorHash = "sha256-495bUr3Cuo7kuhuNLMVhrVg9NXTAXyFmnXRmBrCHovA=";
    }).goModules;

  # it seems that ENABLE_DIST_PKG rejects apple because of symbol versioning,
  # but we disable symbol versioning ourselves.
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "if(NOT UNIX OR APPLE)" "if(NOT UNIX)"
  '';

  preConfigure = ''
    ln -s ${finalAttrs.goDeps} vendor
  '';

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" useSharedLibraries)
    (lib.cmakeBool "GENERATE_RUST_BINDINGS" withRustBindings)
    (lib.cmakeBool "ENABLE_DIST_PKG" true)
    (lib.cmakeBool "ENABLE_DIST_PKG_OPENSSL_SHIM" withOpenSSLShim)
    (lib.cmakeBool "ENABLE_SYMBOL_VERSIONING" false)
  ]
  ++ lib.optionals stdenv.cc.isGNU [
    # Needed with gcc but breaks with clang
    (lib.cmakeFeature "CMAKE_C_FLAGS" "-Wno-error=stringop-overflow")
  ]
  ++ lib.optionals (symbolPrefix != null) [
    (lib.cmakeFeature "BORINGSSL_PREFIX" symbolPrefix)
    (lib.cmakeFeature "BORINGSSL_PREFIX_SYMBOLS" (toString symbols))
  ];

  doCheck = enableTests;
  checkTarget = "run_tests";
  preCheck = "export AWS_LC_NUM_TEST_WORKERS=$NIX_BUILD_CORES";

  postInstall = ''
    moveToOutput lib/crypto/cmake "$dev"
    moveToOutput lib/ssl/cmake "$dev"
  ''
  + lib.optionalString withRustBindings ''
    moveToOutput share/rust "$dev"
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";

  __darwinAllowLocalNetworking = true;

  passthru = {
    tests = {
      pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      # Test packages
      firecracker-static = pkgsStatic.firecracker;
      static = pkgsStatic.aws-lc;
      cross = pkgsCross.aarch64-multiplatform.aws-lc;
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "General-purpose cryptographic library maintained by the AWS Cryptography team for AWS and their customers";
    homepage = "https://github.com/aws/aws-lc";
    changelog = "https://github.com/aws/aws-lc/releases/tag/v${finalAttrs.version}";
    identifiers.cpeParts = lib.meta.cpeFullVersionWithVendor "amazon" finalAttrs.version // {
      product = "aws_libcrypto";
    };
    license =
      with lib.licenses;
      OR [
        asl20
        isc
      ];
    mainProgram = "aws-lc-bssl";
    maintainers = with lib.maintainers; [
      whispersofthedawn
    ];
    pkgConfigModules = [
      "aws-lc"
      "libcrypto-awslc"
      "libssl-awslc"
    ];
    platforms = lib.platforms.unix;
  };
})
