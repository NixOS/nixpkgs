{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "reindeer";
  version = "2026.02.09.00";

  src = fetchFromGitHub {
    owner = "facebookincubator";
    repo = "reindeer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ju+HrYSW0m2vcz5UKyxkXdOhBl34KPWEfHSj8iXoTeY=";
  };

  cargoHash = "sha256-ltPZYyWfb4018OCbTKdz/M4Y8MXIrSdZswnwRxfs1qk=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Generate Buck build rules from Rust Cargo dependencies";
    mainProgram = "reindeer";
    homepage = "https://github.com/facebookincubator/reindeer";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ amaanq ];
  };
})
