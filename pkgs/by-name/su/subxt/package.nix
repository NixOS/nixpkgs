{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, cmake
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "subxt";
  version = "0.40.0";

  src = fetchFromGitHub {
    owner = "paritytech";
    repo = "subxt";
    rev = "v${version}";
    hash = "sha256-U9gErJP+aex5vT3yy4kNad0/0ofdVtrN03tITVIEgzw=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-W1S6CPhfGvfQmlzLDiCxeWZoepNlClTmHOfJNo3f8oQ=";

  # Only build the command line client
  cargoBuildFlags = [ "--bin" "subxt" ];

  # Needed by wabt-sys
  nativeBuildInputs = [ cmake ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  # Requires a running substrate node
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/paritytech/subxt";
    description = "Submit transactions to a substrate node via RPC";
    mainProgram = "subxt";
    license = with licenses; [ gpl3Plus asl20 ];
    maintainers = [ maintainers.FlorianFranzen ];
  };
}
