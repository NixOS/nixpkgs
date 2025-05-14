{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "jnv";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "ynqa";
    repo = "jnv";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HKZ+hF5Y7vTA4EODSAd9xYJHaipv5YukTl470ejPLtM=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-VLVoURqmUhhekNZ0a75bwjvSiLfaQ79IlltbmWVyBrI=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Interactive JSON filter using jq";
    mainProgram = "jnv";
    homepage = "https://github.com/ynqa/jnv";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [
      nealfennimore
      nshalman
    ];
  };
})
