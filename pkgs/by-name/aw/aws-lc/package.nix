{
  lib,
  stdenv,
  overrideSDK,
  cmakeMinimal,
  fetchFromGitHub,
  ninja,
  testers,
  aws-lc,
  useSharedLibraries ? !stdenv.targetPlatform.isStatic,
  ...
}:
let
  awsStdenv = if stdenv.hostPlatform.isDarwin then overrideSDK stdenv "11.0" else stdenv;
in
awsStdenv.mkDerivation (finalAttrs: {
  pname = "aws-lc";
  version = "1.37.0";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "aws-lc";
    rev = "v${finalAttrs.version}";
    hash = "sha256-jgzUre8hjj689YycZZAsNO0KraLB5HuCR/JEfczn0h8=";
  };

  outputs = [
    "out"
    "bin"
    "dev"
  ];

  nativeBuildInputs = [
    cmakeMinimal
    ninja
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" useSharedLibraries)
    "-GNinja"
    "-DDISABLE_GO=ON"
    "-DDISABLE_PERL=ON"
    "-DBUILD_TESTING=ON"
  ];

  doCheck = true;

  checkPhase = ''
    ninja run_minimal_tests
  '';

  env.NIX_CFLAGS_COMPILE = toString (
    lib.optionals stdenv.cc.isGNU [
      # Needed with GCC 12 but breaks on darwin (with clang)
      "-Wno-error=stringop-overflow"
    ]
  );

  postFixup = ''
    for f in $out/lib/crypto/cmake/*/crypto-targets.cmake; do
      substituteInPlace "$f" \
        --replace-fail 'INTERFACE_INCLUDE_DIRECTORIES "''${_IMPORT_PREFIX}/include"' 'INTERFACE_INCLUDE_DIRECTORIES ""'
    done
  '';

  passthru.tests = {
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

  meta = {
    description = "General-purpose cryptographic library maintained by the AWS Cryptography team for AWS and their customers";
    homepage = "https://github.com/aws/aws-lc";
    license = [
      lib.licenses.asl20 # or
      lib.licenses.isc
    ];
    maintainers = [ lib.maintainers.theoparis ];
    platforms = lib.platforms.all;
    mainProgram = "bssl";
  };
})
