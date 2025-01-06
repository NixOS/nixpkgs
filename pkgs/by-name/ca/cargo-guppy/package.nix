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
  pname = "cargo-guppy";
  version = "unstable-2025-01-05";

  src = fetchFromGitHub {
    owner = "guppy-rs";
    repo = "guppy";
    rev = "78b252665d044488086958e09c29bcd5580c4f41";
    sha256 = "sha256-+IjtK4kSm2vThgIxDsBLpoh0j9cDhhEqI6Hr2BmC7hc=";
  };

  cargoHash = "sha256-u39EALYAtS04Bu2bPZsbrJahk8s3aVNdwsosivnTAIk=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs =
    [ openssl ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.Security
    ];

  cargoBuildFlags = [
    "-p"
    "cargo-guppy"
  ];
  cargoTestFlags = [
    "-p"
    "cargo-guppy"
  ];

  meta = with lib; {
    description = "Command-line frontend for guppy";
    mainProgram = "cargo-guppy";
    homepage = "https://github.com/guppy-rs/guppy/tree/main/cargo-guppy";
    license = with licenses; [
      mit # or
      asl20
    ];
    maintainers = with maintainers; [ figsoda ];
  };
}
