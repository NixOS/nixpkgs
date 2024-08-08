{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "crates-io-cli";
  version = "4.0.2";

  src = fetchFromGitHub {
    owner = "Byron";
    repo = "crates-io-cli";
    rev = "v${version}";
    hash = "sha256-28tIN8iopTQzT1RooMiB4UUxk6bHbD9V7t/yecEkLpM=";
  };

  cargoHash = "sha256-d2UKGI5CCN76KNAulGkkpw6aZTnEkCbEc1T3uPDmxC0=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  doCheck = false; # no checks

  meta = {
    description = "Command-line interface to interact with crates.io";
    homepage = "https://github.com/Byron/crates-io-cli";
    license = lib.licenses.mit;
    mainProgram = "crates";
    maintainers = with lib.maintainers; [ aleksana ];
  };
}
