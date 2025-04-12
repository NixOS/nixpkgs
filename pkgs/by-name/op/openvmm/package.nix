{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  protobuf,
}:

rustPlatform.buildRustPackage rec {
  pname = "openvmm";
  version = "0-unstable-2024-10-19";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "openvmm";
    rev = "2e5acb8ab89b75d6ff59d537e9f21445d830386d";
    hash = "sha256-Fi5hDFV2SfpqJjXSc7YwlNDnoL5TTgiqmFMt+ls2Uu4=";
  };

  separateDebugInfo = true;

  env = {
    # Needed to get openssl-sys to use pkg-config.
    OPENSSL_NO_VENDOR = 1;
    PROTOC = "protoc";
  };
  nativeBuildInputs = [
    pkg-config
    protobuf
  ];
  buildInputs = [
    openssl
  ];

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "bitvec-1.1.0" = "sha256-uXOTbrGCSnl/F6IJPZuViZKXg4BEMG4+lVcLxK5KIwc=";
      "ms-tpm-20-ref-0.1.0" = "sha256-eB3MWRlOPtxG55sLH7HIWzSjVEY05IIBZOltTpsGpnE=";
      "mshv-bindings-0.1.1" = "sha256-CZEhFb9qDR260OFA/mlTldEMFlF8bhawVAxXFWqPIcU=";
      "pbjson-build-0.5.1" = "sha256-itmY3c35O7j0Otb1qyr2IDUw1MBWOCB3WwyU60ajBO4=";
    };
  };

  meta = with lib; {
    homepage = "https://github.com/microsoft/openvmm";
    description = "modular, cross-platform Virtual Machine Monitor (VMM), written in Rust";
    license = licenses.mit;
    mainProgram = "openvmm";
    maintainers = with maintainers; [ astro ];
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
  };
}
