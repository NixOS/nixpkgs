{ stdenv
, fetchFromGitHub
, rustPlatform
, pkgconfig
, openssl
}:

rustPlatform.buildRustPackage rec {
  pname = "rumatui";
  version = "0.1.18";

  src = fetchFromGitHub {
    owner = "DevinR528";
    repo = "rumatui";
    rev = version;
    sha256 = "1azqqcb1bgaa9gnb8ym7xfghh7i9wrn188bdzwnlfcdaj16i8rf3";
  };

  cargoSha256 = "08819s3c188wdmd5zwp2ca596abygrs014i0slccipwd2l59ci0m";

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ openssl ];

  meta = with stdenv.lib; {
    description = "WIP Command line Matrix client using matrix-rust-sdk";
    homepage = "https://github.com/DevinR528/rumatui";
    license = licenses.asl20;
    maintainers = with maintainers; [ colemickens ];
  };
}
