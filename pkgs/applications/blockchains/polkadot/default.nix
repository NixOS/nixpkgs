{ stdenv
, fetchFromGitHub
, rustPlatform
, pkgconfig
, openssl
}:

rustPlatform.buildRustPackage rec {
  pname = "polkadot";
  version = "0.2.17";

  src = fetchFromGitHub {
    owner = "paritytech";
    # N.B. In 2018, the thing that was "polkadot" was split off into its own
    # repo, so if this package is ever updated it should be changed to
    # paritytech/polkadot, as per comment here:
    # https://github.com/paritytech/polkadot#note
    repo = "substrate";
    rev = "19f4f4d4df3bb266086b4e488739f73d3d5e588c";
    sha256 = "0v7g03rbml2afw0splmyjh9nqpjg0ldjw09hyc0jqd3qlhgxiiyj";
  };

  cargoSha256 = "1h5v7c7xi2r2wzh1pj6xidrg7dx23w3rjm88mggpq7574arijk4i";

  buildInputs = [ pkgconfig openssl openssl.dev ];

  meta = with stdenv.lib; {
    description = "Polkadot Node Implementation";
    homepage = "https://polkadot.network";
    license = licenses.gpl3;
    maintainers = [ maintainers.akru ];
    platforms = platforms.linux;
    # Last attempt at building this was on v0.7.22
    # https://github.com/paritytech/polkadot/releases
    broken = true;
  };
}
