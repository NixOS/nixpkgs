{
  lib,
  stdenv,
  cmakeMinimal,
  fetchFromGitHub,
  ninja,
  testers,
  aws-lc,
  nix-update-script,
  useSharedLibraries ? !stdenv.hostPlatform.isStatic,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "aws-lc";
<<<<<<< HEAD
  version = "1.66.0";
=======
  version = "1.65.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "aws";
    repo = "aws-lc";
    rev = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-OO9TWwaV/GlyrLl4C6oCFxIAeYfWjzvY7o//7OuoRDc=";
=======
    hash = "sha256-rpxEhOy9qYwIDa78u1BOgANfnkfGgGacKOjjlqXtn88=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
    runHook preCheck
    ninja run_minimal_tests
    runHook postCheck
  '';

  env.NIX_CFLAGS_COMPILE = toString (
    lib.optionals stdenv.cc.isGNU [
      # Needed with GCC 12 but breaks on darwin (with clang)
      "-Wno-error=stringop-overflow"
    ]
  );

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
