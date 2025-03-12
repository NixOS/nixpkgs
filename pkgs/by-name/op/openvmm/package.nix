{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  protobuf,
}:

rustPlatform.buildRustPackage {
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

  cargoHash = "sha256-6ciIbLc/L54Rhhf/IOnv63vUlqoXPi087taw6MY80HA=";
  useFetchCargoVendor = true;

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
