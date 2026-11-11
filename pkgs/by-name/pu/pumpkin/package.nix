{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  nixosTests,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pumpkin";
  version = "0.2.0+26.3-26.51";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Pumpkin-MC";
    repo = "Pumpkin";
    tag = "0.2.0+26.3-26.51";
    hash = "sha256-hV4xWPvdd/vdNEfR6fw0J6jk4JtHIfjC7XtyOLIy8d8=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-AgIPV5zexoA4OqTS4navDQM0U29Tg63JPnIjPrI4ssA=";
  cargoBuildFlags = [
    "--package"
    "pumpkin"
  ];
  cargoTestFlags = [
    "--"
    # require network access / system CA certificates, fail in sandbox
    "--skip=license_checker_offline_and_grace_period"
    "--skip=telemetry::tests::telemetry_client_send_heartbeat_and_shutdown"
  ];

  doCheck = true;

  env = {
    # reduce peak RAM usage during the build
    CARGO_PROFILE_RELEASE_LTO = "thin";
    # split codegen into more units (should reduce memory peak)
    CARGO_PROFILE_RELEASE_CODEGEN_UNITS = "16";
  };

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
