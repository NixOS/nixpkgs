{ stdenv
, fetchFromGitHub
, rustPlatform
, pkgconfig
, openssl
}:

rustPlatform.buildRustPackage rec {
  name = "polkadot-${version}";
  version = "0.2.17";

  src = fetchFromGitHub {
    owner = "paritytech";
    repo = "substrate";
    rev = "19f4f4d4df3bb266086b4e488739f73d3d5e588c";
    sha256 = "0v7g03rbml2afw0splmyjh9nqpjg0ldjw09hyc0jqd3qlhgxiiyj";
  }; 

  cargoSha256 = "0wwkaxqj2v5zach5xcqfzf6prc0gxy2v47janglp44xbxbx9xk08";

  buildInputs = [ pkgconfig openssl openssl.dev ];

  meta = with stdenv.lib; {
    description = "Polkadot Node Implementation";
    homepage = http://polkadot.network;
    license = licenses.gpl3;
    maintainers = [ maintainers.akru ];
    platforms = platforms.linux;
  };
}
