{
  rustPlatform,
  lib,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "kty";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "grampelberg";
    repo = "kty";
    tag = "v${version}";
    hash = "sha256-E9PqWDBKYJFYOUNyjiK+AM2WULMiwupFWTOQlBH+6d4=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  env = {
    OPENSSL_NO_VENDOR = 1;
  };

  buildInputs = [
    openssl
  ];

  cargoHash = "sha256-nJ+nof2YhyLrNuLVy69kYj5tw+aG4IJm6nVxHkczbko=";

  meta = {
    homepage = "https://kty.dev/";
    changelog = "https://github.com/grampelberg/kty/releases/tag/v${version}";
    description = "Terminal for Kubernetes";
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
    platforms = lib.platforms.unix;
    mainProgram = "kty";
  };
}
