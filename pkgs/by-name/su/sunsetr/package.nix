{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sunsetr";
  version = "0.12.6";

  src = fetchFromGitHub {
    owner = "psi4j";
    repo = "sunsetr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DHK+e//wlhMGiUk4Bq5Bb39ryk3YFzYif4ZWd8tmE9s=";
  };

  cargoHash = "sha256-mgOGiPQjqHYczcv09Ha8iPEcsw4kDUP5MCmRj67NrCQ=";

  checkFlags = [
    "--skip=config::tests::test_geo_toml_exists_before_config_creation"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    mainProgram = "sunsetr";
    description = "Automatic blue light filter for Hyprland, Niri, and everything Wayland";
    homepage = "https://github.com/psi4j/sunsetr";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.DoctorDalek1963 ];
  };
})
