{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sunsetr";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "psi4j";
    repo = "sunsetr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XDa6kjhdEur8YDfQQNg+RpLRtfOeTklB6LwXJaPcG7c=";
  };

  cargoHash = "sha256-Jsii8PkRIZgQ4yrQHZpK8bLhaW5jg6EKYw65rPRCtGQ=";

  checkFlags = [
    "--skip=config::tests::test_geo_toml_exists_before_config_creation"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    mainProgram = "sunsetr";
    description = "Automatic blue light filter for Hyprland, Niri, and everything Wayland";
    homepage = "https://github.com/psi4j/sunsetr";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.DoctorDalek1963 ];
  };
})
