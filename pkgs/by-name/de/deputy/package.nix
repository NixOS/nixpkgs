{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "deputy";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "filiptibell";
    repo = "deputy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dTCikfHqfSVb1F6LYrLqFAEufD6dPgAi6F65yPlCO18=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-nGheg/HnkYsvfrsd/dPNbFQEHXFtjB5so436nrbKRqo=";

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
