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
  version = "0.25.0";

  src = fetchFromGitHub {
    owner = "SpikeHD";
    repo = "rsRPC";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zQtCd8d2n41ak+hQbEsjGlsHgbW3n5B5DQZ85icIogs=";
  };

  cargoHash = "sha256-mF2pgg1NmOHM0DE7XUuik0IPp4w4EUs3VRYvBh3ZFK8=";

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
