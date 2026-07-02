{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sunsetr";
  version = "0.12.2";

  src = fetchFromGitHub {
    owner = "psi4j";
    repo = "sunsetr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-M91eW8FKJDlR8pdvXcKte3OL3uJlpapShTUNpnA/Jvo=";
  };

  cargoHash = "sha256-fFk/JPB6MGmYnwARMuKF1/fVZOf+W1C+YqQvuG/ub60=";

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
