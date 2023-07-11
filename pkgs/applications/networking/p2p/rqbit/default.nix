{ lib, stdenv, rustPlatform, fetchFromGitHub, pkg-config, openssl, Security }:

rustPlatform.buildRustPackage rec {
  pname = "rqbit";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "ikatson";
    repo = "rqbit";
    rev = "v${version}";
    hash = "sha256-RF/3eICbqYXSuOWTvRBImiLPWIh4Oip37S5gqoSmDzE=";
  };

  cargoHash = "sha256-wawlqnPYCLEkR9XpTQRZqG+wsqN/Nd5Q1IXpE6ikmY4=";

  nativeBuildInputs = lib.optionals stdenv.isLinux [ pkg-config ];

  buildInputs = lib.optionals stdenv.isLinux [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ Security ];

  doCheck = false;

  meta = with lib; {
    description = "A bittorrent client in Rust";
    homepage = "https://github.com/ikatson/rqbit";
    license = licenses.asl20;
    maintainers = with maintainers; [ marsam ];
  };
}
