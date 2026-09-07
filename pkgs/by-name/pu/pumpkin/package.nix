{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  nixosTests,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pumpkin";
  version = "0.1.0-unstable-2026-07-25";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Pumpkin-MC";
    repo = "Pumpkin";
    rev = "0dfaf5d213e9bc281defa8315945160eddbc7f47";
    hash = "sha256-b2Ws2zUPouJWFDEeqr3zJ+l0G4BQNg+pYo21LBQDSzk=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-xLFfb6ufSw6M6GIMcfvGfVYwN8kccK4+ufwHjdrLJxI=";

  cargoBuildFlags = [
    "--package"
    "pumpkin"
  ];

  doCheck = true;

  passthru = {
    updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };
    tests = {
      nixos = nixosTests.pumpkin;
    };
  };

  meta = {
    description = "Minecraft server built entirely in Rust, focused on performance, compatibility and configurability";
    homepage = "https://pumpkinmc.org/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      DerGrumpf
      jk
    ];
    mainProgram = "pumpkin";
    platforms = lib.platforms.unix;
  };
})
