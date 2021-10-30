{ lib, stdenv, rustPlatform, fetchFromGitHub, pkg-config, openssl, Security }:

rustPlatform.buildRustPackage rec {
  pname = "rqbit";
  version = "2.1.2";

  src = fetchFromGitHub {
    owner = "ikatson";
    repo = "rqbit";
    rev = "v${version}";
    sha256 = "0b9wxjwnhhs3vi1x55isdqck67lh1r7nf3dwmhlwcg5887smwp5c";
  };

  cargoSha256 = "1s278d73mwqpq3n5vmrn5jb6g5dafaaplnhs8346pwcc6y16w3d3";

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
