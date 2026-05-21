{
  fetchFromGitHub,
  gfold,
  lib,
  rustPlatform,
  testers,
  mold,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gfold";
  version = "2026.3.0";

  src = fetchFromGitHub {
    owner = "nickgerace";
    repo = "gfold";
    tag = finalAttrs.version;
    hash = "sha256-iQWcRApAxWGrztEPtsKeaTWcM8gO0CQUA8tNia+bZ1I=";
  };

  cargoHash = "sha256-N7dgB0yzL5JSdQOAhNL9pnCSpV/Mo0Phe6ljwipLD/8=";

  nativeBuildInputs = [ mold ];

  passthru = {
    updateScript = nix-update-script { };

    tests.version = testers.testVersion {
      package = gfold;
      command = "gfold --version";
      inherit (finalAttrs) version;
    };
  };

  meta = {
    description = "CLI tool to help keep track of your Git repositories, written in Rust";
    homepage = "https://github.com/nickgerace/gfold";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ sigmanificient ];
    platforms = lib.platforms.unix;
    mainProgram = "gfold";
  };
})
