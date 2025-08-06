{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  rust-jemalloc-sys,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "oxlint";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "oxc-project";
    repo = "oxc";
    tag = "oxlint_v${finalAttrs.version}";
    hash = "sha256-URgz9k89WgYfCu9OlNCZk5wRt8upt58rIxFWa90L+OQ=";
  };

  cargoHash = "sha256-s1UXL+y/BISOnPJmdpQFztYRd5je9C8jcc+e+iWtRuU=";

  buildInputs = [
    rust-jemalloc-sys
  ];

  env.OXC_VERSION = finalAttrs.version;

  cargoBuildFlags = [
    "--bin=oxlint"
    "--bin=oxc_language_server"
  ];
  cargoTestFlags = finalAttrs.cargoBuildFlags;

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Collection of JavaScript tools written in Rust";
    homepage = "https://github.com/oxc-project/oxc";
    changelog = "https://github.com/oxc-project/oxc/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ figsoda ];
    mainProgram = "oxlint";
  };
})
