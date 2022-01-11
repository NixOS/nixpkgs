{ lib
, rustPlatform
, fetchFromGitHub
, openssl
, pkg-config
}:

rustPlatform.buildRustPackage rec {
  pname = "stork";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "jameslittle230";
    repo = "stork";
    rev = "v${version}";
    sha256 = "sha256-or8PDEj97ChZq6r3WlwETYbU6EvoEuh8HfTyBIbbO8M=";
  };

  cargoSha256 = "sha256-UpIPbY2beO1H0YR9kV1SkG6C3qcO4x2acfgqI3x5jiM=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  meta = with lib; {
    description = "Impossibly fast web search, made for static sites";
    homepage = "https://github.com/jameslittle230/stork";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ chuahou ];
  };
}
