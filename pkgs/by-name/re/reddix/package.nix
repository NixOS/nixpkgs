{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  sqlite,
  stdenv,
  darwin,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "reddix";
  version = "0.2.8";

  src = fetchFromGitHub {
    owner = "ck-zhang";
    repo = "reddix";
    rev = "v${version}";
    hash = "sha256-ZjsM2Q3vKKw47iOZQDBYTkG/CixErMmfniqZITZdhFY=";
  };

  cargoHash = "sha256-YRaV3UjgoW9Ursb1Nmh2z7WI7obc9Ow7z9Le6Gmwx9s=";

  passthru.update-script = nix-update-script { };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    sqlite
  ]
  ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.AppKit
    darwin.apple_sdk.frameworks.CoreServices
    darwin.apple_sdk.frameworks.Security
  ];

  meta = {
    description = "Reddix – Reddit, refined for the terminal";
    homepage = "https://github.com/ck-zhang/reddix";
    changelog = "https://github.com/ck-zhang/reddix/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nebunebu ];
    mainProgram = "reddix";
  };
}
