{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "deputy";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "filiptibell";
    repo = "deputy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-w5//fdH+95x6fneysUxjF0q9bwHNYqtTSods5QID01Y=";
  };

  cargoHash = "sha256-TezOv07Dl99jw8FIqJvx6F8X8Au/aMPC/CXDYLkQDnE=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Language server for tools and package managers";
    homepage = "https://github.com/filiptibell/deputy";
    changelog = "https://github.com/filiptibell/deputy/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ niklaskorz ];
    mainProgram = "deputy";
  };
})
