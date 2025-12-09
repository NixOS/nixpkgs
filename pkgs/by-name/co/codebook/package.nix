{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "codebook";
  version = "0.3.20";

  src = fetchFromGitHub {
    owner = "blopker";
    repo = "codebook";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lsjP230lgQDOLmU4fWR4oUyQ4P2hH5YB9ZvC8ZjeFf0=";
  };

  buildAndTestSubdir = "crates/codebook-lsp";
  cargoHash = "sha256-ifs3C2nNDv3pXq4hfCtBS455Sj4FVz7VEoR5LQIUHFQ=";

  CARGO_PROFILE_RELEASE_LTO = "fat";
  CARGO_PROFILE_RELEASE_CODEGEN_UNITS = "1";

  # Integration tests require internet access for dictionaries
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;
  versionCheckProgramArg = "--version";

  meta = {
    description = "Unholy spellchecker for code";
    homepage = "https://github.com/blopker/codebook";
    changelog = "https://github.com/blopker/codebook/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      jpds
    ];
    mainProgram = "codebook-lsp";
    platforms = with lib.platforms; unix ++ windows;
  };
})
