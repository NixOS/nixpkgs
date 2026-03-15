{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  sqlite,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rtk";
  version = "0.22.2";

  src = fetchFromGitHub {
    owner = "rtk-ai";
    repo = "rtk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dNODYk5PNiKU6+9AgB9c5f06PCcjStwFPEpuIb+BT0g=";
  };

  cargoHash = "sha256-lgmgorgT/KDSyzEcE33qkPF4f/3LJbAzEH0s9thTohE=";

  preBuild = ''
    substituteInPlace Cargo.toml --replace-fail 'features = ["bundled"]' 'features = []'
    cargo update --offline -p rusqlite
  '';

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    sqlite
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI proxy that reduces LLM token consumption by 60-90% on common dev commands";
    homepage = "https://github.com/rtk-ai/rtk";
    changelog = "https://github.com/rtk-ai/rtk/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ryoppippi ];
    mainProgram = "rtk";
  };
})
