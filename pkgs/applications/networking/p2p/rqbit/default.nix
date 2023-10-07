{ lib, stdenv, rustPlatform, fetchFromGitHub, pkg-config, openssl, Security }:

rustPlatform.buildRustPackage rec {
  pname = "rqbit";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "ikatson";
    repo = "rqbit";
    rev = "v${version}";
    hash = "sha256-7n+T+y60RjmZC7bE96Ljg0xVg4bSzV/LFgezTld4zfI=";
  };

  cargoHash = "sha256-hcuZ4hqGJT/O7vFefKPGZlkqhdsAl5LGAcSRQAEopnM=";

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
