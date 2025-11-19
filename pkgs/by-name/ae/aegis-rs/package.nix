{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "aegis-rs";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "Granddave";
    repo = "aegis-rs";
    rev = "v${version}";
    hash = "sha256-QqOZybggHD2+W51+4r1rp2YA4oyJnXsuXdYJCbkOpHo=";
  };

  cargoHash = "sha256-9V4bBgEeuhz008Su4Z1WEVY4CpIbk8BuyRD2vIxtcWY=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.Security
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  meta = {
    description = "CLI tool for generating OTP codes from Aegis Authenticator vault backups";
    homepage = "https://github.com/Granddave/aegis-rs";
    changelog = "https://github.com/Granddave/aegis-rs/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ tennox ];
    mainProgram = "aegis-rs";
    platforms = lib.platforms.all;
  };
}