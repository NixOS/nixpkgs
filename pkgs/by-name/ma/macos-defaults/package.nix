{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "macos-defaults";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "dsully";
    repo = "macos-defaults";
    tag = finalAttrs.version;
    hash = "sha256-dSZjMuw7ott0dgiYo0rqekEvScmrX6iG7xHaPAgo1/E=";
  };

  cargoHash = "sha256-xSg6WAkFPS8B1G4WqMW77egCMmOEo3rK2EKcrDYaBjA=";

  checkFlags = [
    # accesses home dir
    "--skip=defaults::tests::plist_path_tests"
    # accesses system_profiler
    "--skip=defaults::tests::test_get_hardware_uuid"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool for managing macOS defaults declaratively via YAML files";
    homepage = "https://github.com/dsully/macos-defaults";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ josh ];
    mainProgram = "macos-defaults";
    platforms = lib.platforms.darwin;
  };
})
