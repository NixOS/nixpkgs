{
  darwin,
  fetchFromGitHub,
  lib,
  perl,
  pkg-config,
  openssl,
  rustPlatform,
  stdenv,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "screenly-cli";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "screenly";
    repo = "cli";
    rev = "refs/tags/v${version}";
    hash = "sha256-iEz6LFPzOZCOvUMx3s6entcwyEsAKirY8CiIoId/Ie0=";
  };

  cargoHash = "sha256-YurXcmjL44TBrLQocbCKtOEpG7d49aKU9Q/3vPoPvHg=";

  nativeBuildInputs = [
    pkg-config
    perl
  ];

  buildInputs =
    [ openssl ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.CoreFoundation
      darwin.apple_sdk.frameworks.CoreServices
      darwin.apple_sdk.frameworks.Security
      darwin.apple_sdk.frameworks.SystemConfiguration
    ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tools for managing digital signs and screens at scale";
    homepage = "https://github.com/Screenly/cli";
    changelog = "https://github.com/Screenly/cli/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "screenly";
    maintainers = with lib.maintainers; [
      jnsgruk
      vpetersson
    ];
  };
}
