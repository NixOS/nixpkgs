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
  edgedb,
  testers,
}:
rustPlatform.buildRustPackage rec {
  pname = "edgedb";
  version = "6.1.2";

  src = fetchFromGitHub {
    owner = "edgedb";
    repo = "edgedb-cli";
    tag = "v${version}";
    hash = "sha256-7epi7cF6u3Y/Fomcd1+lQfIIRKzuqL6Qk3gTZGZnjv8=";
    fetchSubmodules = true;
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-Iq960LU3Xxu5LHBENsZ48diPVJrdTHxtChtSp7yghCw=";
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
    package = edgedb;
    command = "edgedb --version";
  };

  meta = {
    description = "EdgeDB cli";
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
