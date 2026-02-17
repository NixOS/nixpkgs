{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "polarity";
  version = "latest-unstable-2026-01-29";

  src = fetchFromGitHub {
    owner = "polarity-lang";
    repo = "polarity";
    rev = "d83922b7bbac56c8c06265c1a23a04687caa3322";
    hash = "sha256-E1EzX4RKwL72cqqHzbkAM7O5b+t896MxC5ni53uSh84=";
  };

  cargoHash = "sha256-4oDFW2Ob098BVRXiDRbBwRM+vIATbximzG54BKSA9+I=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Language with Dependent Data and Codata Types";
    homepage = "https://polarity-lang.github.io/";
    changelog = "https://github.com/polarity-lang/polarity/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = [ lib.maintainers.mangoiv ];
    mainProgram = "pol";
    platforms = lib.platforms.all;
  };
})
