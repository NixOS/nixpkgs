{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "railway";
  version = "4.35.0";

  src = fetchFromGitHub {
    owner = "railwayapp";
    repo = "cli";
    rev = "v${finalAttrs.version}";
    hash = "sha256-l4cicdFMP2qSWYpVfqY+TfLKTvIW4ikTEKfSQum2aQo=";
  };

  cargoHash = "sha256-pgaTJ2eus3LIMjUSCjNhn1duD+j9CSzzrRK/WO64Ho8=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  env.OPENSSL_NO_VENDOR = 1;

  meta = {
    mainProgram = "railway";
    description = "Railway.app CLI";
    homepage = "https://github.com/railwayapp/cli";
    changelog = "https://github.com/railwayapp/cli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      Crafter
      techknowlogick
    ];
  };
})
