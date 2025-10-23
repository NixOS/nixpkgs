{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "koto-ls";
  version = "0.16.1";

  src = fetchFromGitHub {
    owner = "koto-lang";
    repo = "koto-ls";
    tag = "v${finalAttrs.version}";
    hash = "sha256-k3XzVfuObA+PyE45arZvp1aER/6uDOyMzs937K8VECQ=";
  };

  cargoHash = "sha256-4mHl9Pds2B4Htkpm425LBHADaR2E2VwvhYC1FwDu304=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Language server for Koto";
    homepage = "https://github.com/koto-lang/koto-ls";
    changelog = "https://github.com/koto-lang/koto-ls/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ defelo ];
    mainProgram = "koto-ls";
  };
})
