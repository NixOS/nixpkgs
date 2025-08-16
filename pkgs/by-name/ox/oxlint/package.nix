{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cmake,
  nix-update-script,
  rust-jemalloc-sys,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "oxlint";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "oxc-project";
    repo = "oxc";
    tag = "oxlint_v${finalAttrs.version}";
    hash = "sha256-7EcXsS600kINm/KB8tTMt0z9eQMyJmisnn/fsCS/2qk=";
  };

  cargoHash = "sha256-FwHknur1hkuOy6EkSGoePtMOvckgV56C3ZnPl2RNilM=";

  nativeBuildInputs = [ cmake ];
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
