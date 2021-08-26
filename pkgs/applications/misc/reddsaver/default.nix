{ lib, stdenv
, fetchFromGitHub
, rustPlatform
, openssl
, pkg-config
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "reddsaver";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "manojkarthick";
    repo = "reddsaver";
    rev = "v${version}";
    sha256 = "1czsy1bb0ja650sndwzq9rcbbhcci7s7ablw0agaynhi403shavv";
  };

  cargoSha256 = "0wr6y7mfffaqdh6i5nqhx692dih159121sm6k0i37wcdvxhvd51z";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ]
    ++ lib.optional stdenv.isDarwin Security;

  # package does not contain tests as of v0.3.3
  docCheck = false;

  meta = with lib; {
    description = "CLI tool to download saved media from Reddit";
    homepage = "https://github.com/manojkarthick/reddsaver";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = [ maintainers.manojkarthick ];
  };

}
