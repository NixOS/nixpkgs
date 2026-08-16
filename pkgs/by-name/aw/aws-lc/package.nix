{
  lib,
  stdenv,
  cmakeMinimal,
  fetchFromGitHub,
  ninja,
  rust-bindgen,
  testers,
  aws-lc,
  nix-update-script,
  useSharedLibraries ? !stdenv.hostPlatform.isStatic,
  withRustBindings ? true,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "aws-lc";
  version = "5.0.0";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "aws-lc";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Dvy6mzEfKgimxCGp7q2fPk9urBMJMU6gZmaZXwdZfWw=";
  };

  outputs = [
    "out"
    "bin"
    "dev"
  ];

  nativeBuildInputs = [
    cmakeMinimal
    ninja
  ]
  ++ lib.optionals withRustBindings [
    rust-bindgen
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" useSharedLibraries)
    (lib.cmakeBool "GENERATE_RUST_BINDINGS" withRustBindings)
    "-GNinja"
    "-DDISABLE_GO=ON"
    "-DDISABLE_PERL=ON"
    "-DBUILD_TESTING=ON"
  ];

  doCheck = true;

  checkPhase = ''
    runHook preCheck
    ninja run_minimal_tests
    runHook postCheck
  '';

  postInstall = ''
    moveToOutput lib/crypto/cmake "$dev"
    moveToOutput lib/ssl/cmake "$dev"
  ''
  + lib.optionalString withRustBindings ''
    moveToOutput share/rust "$dev"
  '';

  env.NIX_CFLAGS_COMPILE = toString (
    lib.optionals stdenv.cc.isGNU [
      # Needed with GCC 12 but breaks on darwin (with clang)
      "-Wno-error=stringop-overflow"
    ]
  );

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
        package = aws-lc;
        command = "bssl version";
      };
      pkg-config = testers.hasPkgConfigModules {
        package = aws-lc;
        moduleNames = [
          "libcrypto"
          "libssl"
          "openssl"
        ];
      };
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "General-purpose cryptographic library maintained by the AWS Cryptography team for AWS and their customers";
    homepage = "https://github.com/aws/aws-lc";
    license = [
      lib.licenses.asl20 # or
      lib.licenses.isc
    ];
    maintainers = [ lib.maintainers.theoparis ];
    platforms = lib.platforms.unix;
    mainProgram = "bssl";
  };
})
