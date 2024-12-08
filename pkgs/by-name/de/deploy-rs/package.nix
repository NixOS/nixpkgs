{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  darwin,
}:

rustPlatform.buildRustPackage {
  pname = "deploy-rs";
  version = "0-unstable-2024-06-12";

  src = fetchFromGitHub {
    owner = "serokell";
    repo = "deploy-rs";
    rev = "3867348fa92bc892eba5d9ddb2d7a97b9e127a8a";
    hash = "sha256-FaGrf7qwZ99ehPJCAwgvNY5sLCqQ3GDiE/6uLhxxwSY=";
  };

  cargoHash = "sha256-lsW810bktMzHZIbuN3pz9N+IUcjNtE5J2AuB/G6pGWI=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.CoreServices
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  meta = {
    description = "Multi-profile Nix-flake deploy tool";
    homepage = "https://github.com/serokell/deploy-rs";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ teutat3s ];
    mainProgram = "deploy";
  };
}
