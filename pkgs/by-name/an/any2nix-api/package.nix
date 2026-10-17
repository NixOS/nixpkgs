{
  fetchFromGitHub,
  lib,
  nix-update-script,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "any2nix-api";
  version = "0.1.5";
  __structuredAttrs = true;
  src = fetchFromGitHub {
    owner = "gbr-ufs";
    repo = "any2nix";
    tag = "${finalAttrs.pname}-v${finalAttrs.version}";
    hash = "sha256-RfRxb1nSWbrLBt1/Pqu4wcqPlNac94J6GhtwWUzqxYg=";
  };
  cargoHash = "sha256-k+7FXcyn5hdW3da9xFMePaZZ90ET3zrq0HtSHgGdS0I=";
  buildAndTestSubdir = "any2nix-api";
  passthru.updateScript = nix-update-script { };
  meta = {
    description = "JSON-based API for translating from different formats to Nix.";
    homepage = "https://github.com/gbr-ufs/any2nix";
    changelog = "https://github.com/gbr-ufs/any2nix/raw/${finalAttrs.pname}-v${finalAttrs.version}/${finalAttrs.pname}/CHANGELOG.md";
    license = with lib.licenses; [
      gpl3Plus
    ];
    mainProgram = "any2nix-api";
    maintainers = with lib.maintainers; [
      gbr-ufs
    ];
  };
})
