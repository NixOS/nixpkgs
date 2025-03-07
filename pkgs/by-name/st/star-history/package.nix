{
  lib,
  rustPlatform,
  darwin,
  fetchCrate,
  pkg-config,
  openssl,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "star-history";
  version = "1.0.27";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-IpMhCI6XS6h7kHaohCdS0YAUUR6PeC9mbMRCiS3p29c=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-bu7YUwrLKHdDL+rxw++8mrWH2hBhEF4jNqZls/9F+aM=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs =
    [ openssl ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.SystemConfiguration
    ];

  meta = with lib; {
    description = "Command line program to generate a graph showing number of GitHub stars of a user, org or repo over time";
    homepage = "https://github.com/dtolnay/star-history";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "star-history";
  };
}
