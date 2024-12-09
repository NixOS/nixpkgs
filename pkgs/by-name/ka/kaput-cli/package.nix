{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "kaput-cli";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "davidchalifoux";
    repo = "kaput-cli";
    rev = "refs/tags/v${version}";
    hash = "sha256-sy8k9L9rmiRFzvhLc+hYl9OqmmP8INLxMNRjAx7/V8g=";
  };

  cargoHash = "sha256-fnTcCVppI5wIzwG2fA8LjpC1+gTAhdRkWv/EQXUok0c=";

  env = {
    OPENSSL_NO_VENDOR = 1;
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/davidchalifoux/kaput-cli/releases/tag/v${version}";
    description = "unofficial CLI client for Put.io";
    homepage = "https://kaput.sh/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
    mainProgram = "kaput";
  };
}
