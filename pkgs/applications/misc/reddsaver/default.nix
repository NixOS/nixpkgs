{ lib, stdenv
, fetchFromGitHub
, rustPlatform
, openssl
, pkg-config
, Security
}:

rustPlatform.buildRustPackage rec {
  version = "0.2.2";
  pname = "reddsaver";

  src = fetchFromGitHub {
    owner = "manojkarthick";
    repo = "reddsaver";
    rev = "v${version}";
    sha256 = "0802jz503jhyz5q6mg1fj2bvkl4nggvs8y03zddd298ymplx5dbx";
  };

  cargoSha256 = "0z8q187331j3rxj8hzym25pwrikxbd0r829v29y8w6v5n0hb47fs";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ]
    ++ lib.optional stdenv.isDarwin Security;

  # package does not contain tests as of v0.2.2
  docCheck = false;

  meta = with lib; {
    description = "CLI tool to download saved images from Reddit";
    homepage = "https://github.com/manojkarthick/reddsaver";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = [ maintainers.manojkarthick ];
  };

}
