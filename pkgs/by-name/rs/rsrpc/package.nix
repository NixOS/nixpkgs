{
  lib,
  fetchFromGitHub,
  rustPlatform,
  openssl,
  pkg-config,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rsrpc";
  version = "0.24.3";

  src = fetchFromGitHub {
    owner = "SpikeHD";
    repo = "rsRPC";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qQduMRITva425T+w2sWX/mRmJLq2SsfPkFzgjyq9x9E=";
  };

  cargoHash = "sha256-aUTy+8XCUgsBEBBWr0PmvZ6agkq0sojXPWi9rDWp2Iw=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  meta = {
    changelog = "https://github.com/SpikeHD/rsRPC/releases/tag/v${finalAttrs.version}";
    description = "Rust implementation of the Discord RPC server";
    homepage = "https://github.com/SpikeHD/rsRPC";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.pyrox0 ];
    mainProgram = "rsrpc-cli";
  };
})
