{
  lib,
  rustPlatform,
  fetchCrate,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "stylance-cli";
  version = "0.7.4";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-lGgKmNqZ0nflVAM3GMDwGgxnXyLCqVz1bTUsvabXmj8=";
  };

  cargoHash = "sha256-HWZQNEKTyNnmA1twN5cfo5RY2tOeCnL6zEp+M4F+Tqg=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "--version";

  meta = {
    description = "Library and cli tool for working with scoped CSS in rust";
    mainProgram = "stylance";
    homepage = "https://github.com/basro/stylance-rs";
    changelog = "https://github.com/basro/stylance-rs/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ dav-wolff ];
  };
})
