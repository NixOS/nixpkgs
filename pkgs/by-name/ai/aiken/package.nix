{
  lib,
  openssl,
  pkg-config,
  rustPlatform,
  fetchFromGitHub,
  darwin,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "aiken";
  version = "1.1.0"; # all releases are 'alpha'

  src = fetchFromGitHub {
    owner = "aiken-lang";
    repo = "aiken";
    rev = "v${version}";
    hash = "sha256-5wPF67S3XXY/mxuYaxrUrfysb9yQl2fX5PZ89H4xNkI=";
  };

  cargoHash = "sha256-yBi6h6XuyI0r4Ru/aa0LRPgyMetzlEJyvB/DgizzkDU=";

  buildInputs =
    [ openssl ]
    ++ lib.optionals stdenv.isDarwin (
      with darwin.apple_sdk.frameworks;
      [
        Security
        CoreServices
        SystemConfiguration
      ]
    );

  nativeBuildInputs = [ pkg-config ];

  meta = {
    description = "Modern smart contract platform for Cardano";
    homepage = "https://aiken-lang.org";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ t4ccer ];
    mainProgram = "aiken";
  };
}
