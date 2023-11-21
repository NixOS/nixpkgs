{ lib, stdenv, rustPlatform, fetchFromGitHub, pkg-config, openssl, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "rqbit";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "ikatson";
    repo = "rqbit";
    rev = "v${version}";
    hash = "sha256-bPLbraHxP/rV9OJROOx8nULycAsmwPzF3LGkgQFRfBk=";
  };

  cargoHash = "sha256-j4iW9/ixoUu8W9yAhqIsflBQKRFiCbEtUVHhb775ezA=";

  nativeBuildInputs = lib.optionals stdenv.isLinux [ pkg-config ];

  buildInputs = lib.optionals stdenv.isLinux [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.SystemConfiguration ];

  doCheck = false;

  meta = with lib; {
    description = "A bittorrent client in Rust";
    homepage = "https://github.com/ikatson/rqbit";
    license = licenses.asl20;
    maintainers = with maintainers; [ marsam ];
    mainProgram = "rqbit";
  };
}
