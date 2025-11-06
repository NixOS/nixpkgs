{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lacy";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "timothebot";
    repo = "lacy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-blQPIw8Ct+TGRuy+ybYr9rdlfOZdvAbhsB8sfwugS/w=";
  };

  passthru.updateScript = nix-update-script { };

  cargoHash = "sha256-rNTRcQJptVi/ruCd56oHHN9n+Z3NhUNyrvXf27Sovtw=";

  meta = {
    description = "Fast magical cd alternative for lacy terminal navigators";
    homepage = "https://github.com/timothebot/lacy";
    platforms = lib.platforms.all;
    license = lib.licenses.mit;
    mainProgram = "lacy";
    maintainers = with lib.maintainers; [ Srylax ];
  };
})
