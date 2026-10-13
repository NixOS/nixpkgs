{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "deputy";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "filiptibell";
    repo = "deputy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OdIhRdJvuSlZoKO0bDVplbcASc0w7iO9b1FnY8Uf33o=";
  };

  cargoHash = "sha256-pnpL3hLaJRo3VJ9EK5ewYHu/2JJtkvd7VUFeMq0kJKQ=";

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
