{ stdenv, fetchFromGitHub, rustPlatform
, pkgconfig, perl, openssl, libudev }:

with rustPlatform;

buildRustPackage rec {
  name = "parity-${version}";
  version = "1.6.5";

  src = fetchFromGitHub {
    owner = "paritytech";
    repo = "parity";
    rev = "987390fb7d9f42a97c34aba254a8b9d8efd461d7";
    sha256 = "19cn0yh043il3dwcg7x69paw2b5iqq6fb8lwrkarvnfvjsg6a39s";
  };

  depsSha256 = "0y07kjgyn4znw0xqmh5v10f1g7yk0lj81l1zyz2gwxz2wq8h54hr";

  buildInputs = [ perl openssl libudev ];
  nativeBuildInputs = [ pkgconfig ];

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Fast, light, robust Ethereum implementation, written in Rust";
    homepage = https://github.com/paritytech/parity;
    maintainers = [ maintainers.mkoenig ];
    inherit version;
  };
}
