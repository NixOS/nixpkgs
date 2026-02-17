{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "codebook";
  version = "0.3.30";

  src = fetchFromGitHub {
    owner = "blopker";
    repo = "codebook";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TpHaUtNU6U3OlA7YmqY4roB/NdusMffZCsPkoi/lPUM=";
  };

  buildAndTestSubdir = "crates/codebook-lsp";
  cargoHash = "sha256-hxPgYGBq+KZfEyFiHQG31cNEN6A6hUgKRgZXIHOGalw=";

  CARGO_PROFILE_RELEASE_LTO = "fat";
  CARGO_PROFILE_RELEASE_CODEGEN_UNITS = "1";

  # Integration tests require internet access for dictionaries
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

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
