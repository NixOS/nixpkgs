{ lib, stdenv, rustPlatform, fetchFromGitHub, pkg-config, openssl, Security }:

rustPlatform.buildRustPackage rec {
  pname = "rqbit";
  version = "2.1.4";

  src = fetchFromGitHub {
    owner = "ikatson";
    repo = "rqbit";
    rev = "v${version}";
    sha256 = "sha256-PkU3QJvAK2b1KQC1o5md35iucjq+SYoKAGxqiojf4rw=";
  };

  cargoSha256 = "sha256-Jj2CK3nwktv2MU+EHXzQ/lKDUlC+4HkaItMTtoGF1Pw=";

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
