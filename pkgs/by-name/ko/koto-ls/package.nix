{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "koto-ls";
  version = "0.15.3";

  src = fetchFromGitHub {
    owner = "koto-lang";
    repo = "koto-ls";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4s+zWiI6Yxv1TB0drds27txnL0kE6RoqjRI36Clls6Y=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-ewBAixbksI9ora5hBZR12lzxCPzxM2Cp6GvQz6hGCSY=";

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
