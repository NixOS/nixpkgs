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
  version = "0.2.7";

  src = fetchFromGitHub {
    owner = "screenly";
    repo = "cli";
    rev = "refs/tags/v${version}";
    hash = "sha256-ls8QnOfWRBAkW3q7eFKyoxvHlcI6j/zwIZNn8SMNzy8=";
  };

  cargoHash = "sha256-rRH9bmsVylGZqMy7qIZlOk4kWBzj7uCruj30/z1nqEE=";

  nativeBuildInputs = [
    pkg-config
    perl
  ];

  buildInputs =
    [
      openssl
    ]
    ++ lib.optionals stdenv.isDarwin [
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
