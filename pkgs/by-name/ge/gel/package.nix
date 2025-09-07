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
  version = "7.7.0";

  src = fetchFromGitHub {
    owner = "geldata";
    repo = "gel-cli";
    tag = "v${version}";
    hash = "sha256-4dFajTGYczolQXnpcRBPWCD68EUiPVDRGIMwGh/K2UY=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-4LLGg+f8Q7jskQr/wY0eCDkn9bC+zDpMvyF5D0A1oG4=";
  };

  nativeBuildInputs = [
    makeBinaryWrapper
    pkg-config
  ];

  buildInputs = [
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
