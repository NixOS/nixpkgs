{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hath-rust";
  version = "1.14.2";

  src = fetchFromGitHub {
    owner = "james58899";
    repo = "hath-rust";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aGdQ0nBrLOSs1xgbgn/e1e9QPMDlmpNJvmMtwvAOeVQ=";
  };

  cargoHash = "sha256-1DibBXpg1x04wE+URSqemxqpuR9wgVJqWIIosZwAZ2k=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Unofficial Hentai@Home client written in Rust";
    homepage = "https://github.com/james58899/hath-rust";
    changelog = "https://github.com/james58899/hath-rust/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ moraxyc ];
    mainProgram = "hath-rust";
  };
})
