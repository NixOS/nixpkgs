{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "stylance-cli";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "basro";
    repo = "stylance-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YMC7pldkabU669CKeXX5QQOcN974/cZ42nTPphZPq5U=";
  };

  cargoHash = "sha256-hn1nEnihgWtj1JaRcUZTm6lrThnugUMs6mAs0lsWpbU=";

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
