{
  rustPlatform,
  lib,
  fetchFromGitHub,
  pkg-config,
  openssl,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "kty";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "grampelberg";
    repo = "kty";
    rev = "refs/tags/v${version}";
    hash = "sha256-E9PqWDBKYJFYOUNyjiK+AM2WULMiwupFWTOQlBH+6d4=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  env = {
    OPENSSL_NO_VENDOR = 1;
  };

  buildInputs =
    [
      openssl
    ]
    ++ lib.optionals stdenv.isDarwin (
      with darwin.apple_sdk;
      [
        frameworks.SystemConfiguration
      ]
    );

  cargoHash = "sha256-mhXi4YgYT2NfIjtESjvSP5TMOl3UH3CJFwKlJriZ0/4=";

  meta = {
    homepage = "https://kty.dev/";
    changelog = "https://github.com/grampelberg/kty/releases/tag/v${version}";
    description = "Terminal for Kubernetes";
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
    platforms = lib.platforms.unix;
    mainProgram = "kty";
  };
}
