{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hath-rust";
  version = "1.15.0";

  src = fetchFromGitHub {
    owner = "james58899";
    repo = "hath-rust";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jFpoEN2tH7uSJzs2XvvIcl4ZWY1DfupKhINoO37MVAw=";
  };

  cargoHash = "sha256-WSh4LxXRCKnE7vo9xM3bJK1s7rxONEnslWbE5YXVBXQ=";

  nativeInstallCheckInputs = [ versionCheckHook ];
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
