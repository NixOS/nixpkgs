{
  lib,
  nixosTests,
  rustPlatform,
  fetchFromGitHub,
  fetchpatch,
  pkg-config,
  protobuf,
  openssl,
  sqlite,
  stdenv,
  darwin,
  adaptor ? "sql",
}:

rustPlatform.buildRustPackage rec {
  pname = "crabfit-api";
  version = "0-unstable-2023-08-02";

  src = fetchFromGitHub {
    owner = "GRA0007";
    repo = "crab.fit";
    rev = "628f9eefc300bf1ed3d6cc3323332c2ed9b8a350";
    hash = "sha256-jy8BrJSHukRenPbZHw4nPx3cSi7E2GSg//WOXDh90mY=";
  };

  sourceRoot = "${src.name}/api";

  patches = [
    (fetchpatch {
      name = "01-listening-address.patch";
      url = "https://github.com/GRA0007/crab.fit/commit/a1ac6da0f5e9d10df6bef8d735bc9ecaa9088d14.patch";
      relative = "api";
      hash = "sha256-7bmBndS3ow9P9EKmoQrQWcTpS4B3qAnSpeTUF6ox+BM=";
    })
  ];

  # FIXME: Remove this after https://github.com/GRA0007/crab.fit/pull/341 is merged,
  # or upstream bumps their locked version of 0.3 time to 0.3.36 or later
  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock
  '';

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "google-cloud-0.2.1" = "sha256-3/sUeAXnpxO6kzx5+R7ukvMCEM001VoEPP6HmaRihHE=";
    };
  };

  nativeBuildInputs = [
    pkg-config
    protobuf
  ];

  buildInputs =
    [
      openssl
      sqlite
    ]
    ++ lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.CoreFoundation
      darwin.apple_sdk.frameworks.Security
      darwin.apple_sdk.frameworks.SystemConfiguration
    ];

  buildFeatures = [ "${adaptor}-adaptor" ];

  PROTOC = "${protobuf}/bin/protoc";

  passthru.tests = [ nixosTests.crabfit ];

  meta = {
    description = "Enter your availability to find a time that works for everyone";
    homepage = "https://github.com/GRA0007/crab.fit";
    license = lib.licenses.gpl3;
    maintainers = [ ];
    mainProgram = "crabfit-api";
  };
}
