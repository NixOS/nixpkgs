{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "deputy";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "filiptibell";
    repo = "deputy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NBtVIe4ZMNiOgCoIbngk4ECqT0hwe7rsWye6QFJrdPg=";
  };

  cargoHash = "sha256-ZwBWmOVFRAlWg+nmnzCue7F8XBhpuX+yp2PlEntB5Oo=";

  nativeInstallCheckInputs = [ versionCheckHook ];
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
