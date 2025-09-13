{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hath-rust";
  version = "1.12.1";

  src = fetchFromGitHub {
    owner = "james58899";
    repo = "hath-rust";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4dbloi88oR84JnD1nepLTJNSgxgB337F3nxr7i4nZV8=";
  };

  cargoHash = "sha256-P975lZ6LgL+dT52td8uA8QVnuJd6QKWkpBCfoLpLW9E=";

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
