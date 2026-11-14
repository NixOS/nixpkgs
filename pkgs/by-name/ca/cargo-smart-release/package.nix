{
  lib,
  rustPlatform,
  fetchFromGitHub,
  git,
  pkg-config,
  openssl,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-smart-release";
  version = "0.21.8";

  src = fetchFromGitHub {
    owner = "GitoxideLabs";
    repo = "cargo-smart-release";
    tag = "v${finalAttrs.version}";
    hash = "sha256-T7rdNncK3nukjQb90A49jlLqs4Gy/HUUs7yiDi76GrU=";
  };

  cargoHash = "sha256-oFuOf7RtV0nRHk0woV11gdqw0mtFskTydC6L/cZf6JE=";

  nativeBuildInputs = [
    git
    pkg-config
  ];

  buildInputs = [ openssl ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Release complex cargo-workspaces automatically with changelog generation";
    homepage = "https://github.com/GitoxideLabs/cargo-smart-release";
    changelog = "https://github.com/GitoxideLabs/cargo-smart-release/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ higherorderlogic ];
    mainProgram = "cargo-smart-release";
  };
})
