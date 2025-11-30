{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:
rustPlatform.buildRustPackage rec {
  pname = "railway";
  version = "4.11.0";

  src = fetchFromGitHub {
    owner = "railwayapp";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-3MqMkef/oc6Fk2PHvdTMlH/lRU19Tru5uqs8yVThSdw=";
  };

  cargoHash = "sha256-JYsnrZsUrESOZQzVOkHLFDDtjDCzGva6mrFLSOiEUzw=";

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
