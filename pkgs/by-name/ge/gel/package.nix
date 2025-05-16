{
  stdenv,
  lib,
  patchelf,
  fetchFromGitHub,
  rustPlatform,
  makeBinaryWrapper,
  pkg-config,
  curl,
  openssl,
  xz,
  replaceVars,
  # for passthru.tests:
  gel,
  testers,
}:
rustPlatform.buildRustPackage rec {
  pname = "gel";
  version = "7.3.0";

  src = fetchFromGitHub {
    owner = "geldata";
    repo = "gel-cli";
    tag = "v${version}";
    hash = "sha256-tMbAU6tlyDcAzUQ8FK0Q0V+LgzHAazETtFuC050hObw=";
    fetchSubmodules = true;
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-IWGOh8VbE0rCIRtiAqGlFExd1u80HWyoluquWVRaQoo=";
  };

  nativeBuildInputs = [
    makeBinaryWrapper
    pkg-config
  ];

  buildInputs =
    [
      curl
    ]
    ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
      openssl
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      xz
    ];

  checkFeatures = [ ];

  patches = [
    (replaceVars ./0001-dynamically-patchelf-binaries.patch {
      inherit patchelf;
      dynamicLinker = stdenv.cc.bintools.dynamicLinker;
    })
  ];

  env = {
    OPENSSL_NO_VENDOR = true;
  };

  doCheck = false;

  passthru.tests.version = testers.testVersion {
    package = gel;
    command = "gel --version";
  };

  meta = {
    description = "Gel cli";
    homepage = "https://docs.geldata.com/reference/cli";
    license = with lib.licenses; [
      asl20
      # or
      mit
    ];
    maintainers = with lib.maintainers; [
      ahirner
      kirillrdy
    ];
    mainProgram = "gel";
  };
}
