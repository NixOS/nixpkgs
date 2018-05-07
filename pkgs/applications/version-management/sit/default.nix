{ stdenv, fetchFromGitHub, rustPlatform, cmake, libzip }:

rustPlatform.buildRustPackage rec {
  name = "sit-${version}";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "sit-it";
    repo = "sit";
    rev = "v${version}";
    sha256 = "0lhl4rrfmsi76498mg5si2xagl8l2pi5d92dxhsyzszpwn5jdp57";
  };

  buildInputs = [ cmake libzip ];

  cargoSha256 = "102haqix13nwcncng1s8qkw68spn6fhh3vysk2nbahw6f78zczqg";

  patches = [ ./aarch64-isel.patch ];

  meta = with stdenv.lib; {
    description = "Serverless Information Tracker";
    homepage = https://sit.sh/;
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ dywedir yrashk ];
    platforms = platforms.all;
  };
}
