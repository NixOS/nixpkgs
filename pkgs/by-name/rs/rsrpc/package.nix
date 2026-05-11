{
  lib,
  fetchFromGitHub,
  rustPlatform,
  openssl,
  pkg-config,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rsrpc";
  version = "0.27.1";

  src = fetchFromGitHub {
    owner = "SpikeHD";
    repo = "rsRPC";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QzPFhdnZXiJZ4g+J9kB2v8duM2PgShptNRHliTYW3AU=";
  };

  cargoHash = "sha256-6Krtsj9hm8NqkFQMQ0MAPrFAjnzcTt4q5C1Fs5mx2SM=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/SpikeHD/rsRPC/releases/tag/v${finalAttrs.version}";
    description = "Rust implementation of the Discord RPC server";
    homepage = "https://github.com/SpikeHD/rsRPC";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.pyrox0 ];
    mainProgram = "rsrpc-cli";
  };
})
