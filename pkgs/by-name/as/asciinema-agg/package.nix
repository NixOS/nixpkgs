{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  darwin,
}:

let
  inherit (darwin.apple_sdk.frameworks) Security;
in
rustPlatform.buildRustPackage rec {
  pname = "agg";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "asciinema";
    repo = "agg";
    rev = "v${version}";
    hash = "sha256-bCE59NeITaCwgajgyXgP6jxtV7aPihPaZ/Uzh39Po1k=";
  };

  strictDeps = true;

  cargoHash = "sha256-K472Qrsi2FIEOxFMi5CDgau2ODU0P3VDQEz/cwzmKiM=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    Security
  ];

  meta = with lib; {
    description = "Command-line tool for generating animated GIF files from asciicast v2 files produced by asciinema terminal recorder";
    homepage = "https://github.com/asciinema/agg";
    changelog = "https://github.com/asciinema/agg/releases/tag/${src.rev}";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "agg";
  };
}
