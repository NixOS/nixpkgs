{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sunsetr";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "psi4j";
    repo = "sunsetr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fV4yb8+a2AbXkvalL9TU9JmPGX04GNE60a8OnQKNuEU=";
  };

  cargoHash = "sha256-Cxdy/4lOf7nFoHaDeLekI0o7xT1ZUjV1yyKoGUcjNGs=";

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
