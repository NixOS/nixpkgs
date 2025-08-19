{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sunsetr";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "psi4j";
    repo = "sunsetr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kFIfNVA1UJrle/5udi8+9uDgq9fArUdudM/v8QpGuaM=";
  };

  cargoLock.lockFile = ./Cargo.lock;

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  checkFlags = [
    "--skip=config::tests::test_geo_toml_exists_before_config_creation"
  ];

  meta = {
    mainProgram = "sunsetr";
    description = "Automatic blue light filter for Hyprland, Niri, and everything Wayland";
    homepage = "https://github.com/psi4j/sunsetr";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.DoctorDalek1963 ];
  };
})
