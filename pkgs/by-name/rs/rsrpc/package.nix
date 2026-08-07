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
  version = "0.28.0";

  src = fetchFromGitHub {
    owner = "SpikeHD";
    repo = "rsRPC";
    tag = "v${finalAttrs.version}";
    hash = "sha256-L07x93mgTbo+v0Wg91XjCNbRYAltHns8WyrsIrr7pZE=";
  };

  cargoHash = "sha256-YTkOneMUTVLv3SWgeRdYpxGB9PIr+C9NHR1SCHOvDUY=";

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
