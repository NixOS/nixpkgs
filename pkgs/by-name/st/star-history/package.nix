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
  version = "1.0.22";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-Ymocx843DVxvtTHBS3PdyYDLgYJJtUMpmdOnOmFKJZE=";
  };

  cargoHash = "sha256-xDO+Qdg8gDj0Eny7QtaRiAxwdXycOsInf5L1YZKv++g=";

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
