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
<<<<<<< HEAD
  version = "7.10.2";
=======
  version = "7.7.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "geldata";
    repo = "gel-cli";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-Fy4J7puunqB5TeUsafnOotoWNvtTGiMJZ06YII14zIM=";
=======
    hash = "sha256-4dFajTGYczolQXnpcRBPWCD68EUiPVDRGIMwGh/K2UY=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
<<<<<<< HEAD
    hash = "sha256-VRZjI8C0u+6MkQgzt0PApeUtrGR5UqvnLZxityMGnDo=";
=======
    hash = "sha256-4LLGg+f8Q7jskQr/wY0eCDkn9bC+zDpMvyF5D0A1oG4=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
    changelog = "https://github.com/geldata/gel-cli/compare/v7.7.0...v7.10.2";
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
