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
  testers,
  nix-update-script,
  aws-lc,
  writableTmpDirAsHomeHook,
  runCommand,
  useSharedLibraries ? !stdenv.hostPlatform.isStatic,
  withRustBindings ? true,
  symbolPrefix ? null,
}:

let
  aws-lc' = aws-lc.override { useSharedLibraries = false; };
  symbols =
    runCommand "aws-lc-symbols"
      {
        inherit (aws-lc) src;
        nativeBuildInputs = [
          writableTmpDirAsHomeHook
          go
        ];
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
  version = "5.12.0";

  patches = [
    ./fix-dynamic-loading-test.patch
  ];

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "aws";
    repo = "aws-lc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-O+0UG6Zk6U9b73B9qDSZ9aC32WL1anJIgH0TRgVpONI=";
  };

  outputs = [
    "out"
    "bin"
    "dev"
  ];

  nativeBuildInputs = [
    writableTmpDirAsHomeHook
    cmake
    ninja
    go
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

  preConfigure = ''
    ln -s ${finalAttrs.goDeps} vendor
  '';

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" useSharedLibraries)
    (lib.cmakeBool "GENERATE_RUST_BINDINGS" withRustBindings)
    (lib.cmakeBool "ENABLE_DIST_PKG" true)
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

  doCheck = true;
  checkTarget = "run_tests";

  postInstall = ''
    moveToOutput lib/crypto/cmake "$dev"
    moveToOutput lib/ssl/cmake "$dev"
  ''
  + lib.optionalString withRustBindings ''
    moveToOutput share/rust "$dev"
  '';

  # AWS-LC's generated *-targets.cmake files hardcode _IMPORT_PREFIX to $out
  # and set INTERFACE_INCLUDE_DIRECTORIES to "$out/include", but headers live
  # in $dev/include under multi-output splitting. Clear the broken claim so
  # consumers fall back to stdenv's normal include-path propagation via
  # buildInputs (which correctly resolves to $dev/include).
  postFixup = ''
    for f in $out/lib/{crypto,ssl}/cmake/*/*-targets.cmake; do
      substituteInPlace "$f" \
        --replace-fail \
          'INTERFACE_INCLUDE_DIRECTORIES "\$<\$<BOOL:1>:>;''${_IMPORT_PREFIX}/include"' \
          'INTERFACE_INCLUDE_DIRECTORIES ""'
    done
  '';

  __darwinAllowLocalNetworking = true;

  passthru = {
    tests = {
      version = testers.testVersion {
        package = finalAttrs.finalPackage;
        command = "bssl version";
      };
      pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
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
    mainProgram = "bssl";
    maintainers = with lib.maintainers; [
      whispersofthedawn
    ];
    pkgConfigModules = [
      "aws-lc"
      "libcrypto"
      "libssl"
      "openssl"
    ];
    platforms = lib.platforms.unix;
  };
})
