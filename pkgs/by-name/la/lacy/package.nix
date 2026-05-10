{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lacy";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "timothebot";
    repo = "lacy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YX/iXlQ3uhmxNr4fpPtxIPhFwXGUJZF8rYe9mU+9Hos=";
  };

  passthru.updateScript = nix-update-script { };

  cargoHash = "sha256-3K8g/AGpSXFUhgEBg/AzUYsH3vOvsRzAYnrOAZNVS4g=";

  meta = {
    description = "Fast magical cd alternative for lacy terminal navigators";
    homepage = "https://github.com/timothebot/lacy";
    platforms = lib.platforms.all;
    license = lib.licenses.mit;
    mainProgram = "lacy";
    maintainers = with lib.maintainers; [ Srylax ];
  };
})
