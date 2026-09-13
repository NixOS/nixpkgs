{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  nixosTests,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pumpkin";
  version = "0.1.0-dev+26.2-26.45";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Pumpkin-MC";
    repo = "Pumpkin";
    tag = "0.1.0-dev+26.2-26.45";
    hash = "sha256-Q5v8vxkDjRPXEKgVg7K1/FFO8jgK0e56V8VMBAK9Vbs=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-BEYk8hB5tQA/Ns071E3zsqDAXF1/C77sI0ii62dFAxc=";
  cargoBuildFlags = [
    "--package"
    "pumpkin"
  ];
  cargoTestFlags = [
    "--"
    # requires network access to fetch CA, fails in sandbox
    "--skip=license_checker_offline_and_grace_period"
  ];

  doCheck = true;

  passthru = {
    updateScript = nix-update-script { };
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
