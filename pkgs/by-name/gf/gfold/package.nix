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
  version = "2025.12.0";

  src = fetchFromGitHub {
    owner = "nickgerace";
    repo = "gfold";
    tag = finalAttrs.version;
    hash = "sha256-lqDKPIWvwu60S6miSQ3TvHxhI9xuiN8VwmEz670UR78=";
  };

  cargoHash = "sha256-g4keAwNMPmhthbKF8uiPcciOVa1gUe1bDsvWtKc/M5I=";

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
