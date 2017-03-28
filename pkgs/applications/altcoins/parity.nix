{ stdenv, fetchFromGitHub, rustPlatform
, pkgconfig, perl, openssl, libudev }:

with rustPlatform;

buildRustPackage rec {
  name = "parity-${version}";
  version = "1.6.4";

  src = fetchFromGitHub {
    owner = "paritytech";
    repo = "parity";
    rev = "1164193019243b76ca4a90e6feff83367bee311e";
    sha256 = "198zjacipi7rljb533pcswxf50jdapgxavfx9c4nanpb2js496c3";
  };

  depsSha256 = "001765dqvrjb07vj3sh3r8lqwmgkbkkcp86n713l8qxa7qnsjddj";

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
