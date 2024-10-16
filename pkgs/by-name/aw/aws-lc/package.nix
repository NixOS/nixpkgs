{
  lib,
  stdenv,
  overrideSDK,
  cmakeMinimal,
  fetchFromGitHub,
  fetchpatch,
  ninja,
  testers,
  aws-lc,
  ...
}:
let
  awsStdenv = if stdenv.hostPlatform.isDarwin then overrideSDK stdenv "11.0" else stdenv;
in
awsStdenv.mkDerivation (finalAttrs: {
  pname = "aws-lc";
  version = "1.36.1";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "aws-lc";
    rev = "v${finalAttrs.version}";
    hash = "sha256-v3fTOhAwdNZVx3Q2DCnUoMmdy11uvrI+yUM2sE0uGGw=";
  };

  patches = [
    # See https://github.com/NixOS/nixpkgs/issues/144170
    (fetchpatch {
      url = "https://github.com/aws/aws-lc/compare/main...tinted-software:aws-lc:main.patch";
      sha256 = "sha256-rXUG1bVYDnjwQC5+Q5E0W02eVlP1PJkt2IWcvgWnXng=";
    })
  ];

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
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.targetPlatform.isStatic))
    "-GNinja"
    "-DDISABLE_GO=ON"
    "-DDISABLE_PERL=ON"
  ];

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
