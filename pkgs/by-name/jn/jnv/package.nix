{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "jnv";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "ynqa";
    repo = "jnv";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sW3wy5m3fnTDIxRC/E/EWEvuJ92o+l4QCmwdqL2tZ98=";
  };

  cargoHash = "sha256-jKeAgeW54lAgcv6Xpz9Rwt10tdac4S4B5EAmwanaW9c=";

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
