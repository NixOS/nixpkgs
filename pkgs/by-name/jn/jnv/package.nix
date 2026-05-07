{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "jnv";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "ynqa";
    repo = "jnv";
    tag = "v${finalAttrs.version}";
    hash = "sha256-m+yntdBXnZEFtDvjXRb/NYKyMFBRL5JJYUz9UTGqCSA=";
  };

  cargoHash = "sha256-Ae+YUtZ/sDBjngxIxYZq5M7edCc8tq1X+7rc3IsJhvc=";

  nativeInstallCheckInputs = [ versionCheckHook ];
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
