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
  version = "2025.9.0";

  src = fetchFromGitHub {
    owner = "nickgerace";
    repo = "gfold";
    rev = finalAttrs.version;
    hash = "sha256-sPvhZaDGInXH2PT8fg28m7wyDZiIE4fFScNO8WIjV9s=";
  };

  cargoHash = "sha256-pbIE8QXY8lYsDGdmGVsOPesVTaHRjDBSd7ihQhN2XrI=";

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
