{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:
rustPlatform.buildRustPackage rec {
  pname = "railway";
  version = "4.12.0";

  src = fetchFromGitHub {
    owner = "railwayapp";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-ViafZYAQCEfNJZpJgWVHG55+Ylkl3xndqT+zuNUDF04=";
  };

  cargoHash = "sha256-CaB6sobEw+Z/R/zjGNonVhIiuX676P/4SA6nwoWWA7g=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  OPENSSL_NO_VENDOR = 1;

  meta = {
    mainProgram = "railway";
    description = "Railway.app CLI";
    homepage = "https://github.com/railwayapp/cli";
    changelog = "https://github.com/railwayapp/cli/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      Crafter
      techknowlogick
    ];
  };
}
