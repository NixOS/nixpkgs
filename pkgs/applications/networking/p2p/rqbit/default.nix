{ lib, stdenv, rustPlatform, fetchFromGitHub, pkg-config, openssl, Security }:

rustPlatform.buildRustPackage rec {
  pname = "rqbit";
  version = "2.1.5";

  src = fetchFromGitHub {
    owner = "ikatson";
    repo = "rqbit";
    rev = "v${version}";
    sha256 = "sha256-AzlYeHPCDri/FxAh5R5AES+OAfzhwqB8/ewRwDU1nnU=";
  };

  cargoSha256 = "sha256-CqEnQNbwiB6+zM8gWhplvFPblKp+mPMAtnHP8JZiKv4=";

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
