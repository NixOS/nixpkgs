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
  version = "7.0.1";

  src = fetchFromGitHub {
    owner = "geldata";
    repo = "gel-cli";
    tag = "v${version}";
    hash = "sha256-/lYMRvpddmr/22bPdLa19rR5tGTfo7EnxRIa/sVa74I=";
    fetchSubmodules = true;
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-yb10UiwA42+uFLs+lFRn1+uvwJe7k8PWx/Hf2f7BvII=";
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
    command = "edgedb --version";
  };

  meta = {
    description = "Gel cli";
    homepage = "https://www.edgedb.com/docs/cli/index";
    license = with lib.licenses; [
      asl20
      # or
      mit
    ];
    maintainers = with lib.maintainers; [
      ahirner
      kirillrdy
    ];
    mainProgram = "edgedb";
  };
}
