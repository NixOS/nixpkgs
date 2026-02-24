{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lacy";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "timothebot";
    repo = "lacy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NjLCN9RDWusfw1BwSzRQLCx4UhHyMpQZ5+igRG1rX9Q=";
  };

  passthru.updateScript = nix-update-script { };

  cargoHash = "sha256-eE/kyb09AwcYTsyXQ9Yn43QF2veCRAgGkNgykJHCsFE=";

  meta = {
    description = "Fast magical cd alternative for lacy terminal navigators";
    homepage = "https://github.com/timothebot/lacy";
    platforms = lib.platforms.all;
    license = lib.licenses.mit;
    mainProgram = "lacy";
    maintainers = with lib.maintainers; [ Srylax ];
  };
})
