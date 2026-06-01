{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sunsetr";
  version = "0.12.3";

  src = fetchFromGitHub {
    owner = "psi4j";
    repo = "sunsetr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hbr7NpJCi2dulzgN2JVtUJewoo7s4rr1zGt+KpKYTWE=";
  };

  cargoHash = "sha256-yOU96xWnpMKzvBo64ewhzktRHLzSBn4ZXdSFrhrejZE=";

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
