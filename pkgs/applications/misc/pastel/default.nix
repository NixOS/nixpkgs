{ lib, stdenv, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "pastel";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "sharkdp";
    repo = pname;
    rev = "v${version}";
    sha256 = "12n1a9j61r4spx0zi2kk85nslv11j1s510asxqvj92ggqhr2s3sq";
  };

  cargoSha256 = "12zachbg78ajx1n1mqp53rd00dzcss5cqhsq0119lalzc8b5zkrn";

  buildInputs = lib.optional stdenv.isDarwin Security;

  meta = with lib; {
    description = "A command-line tool to generate, analyze, convert and manipulate colors";
    homepage = "https://github.com/sharkdp/pastel";
    changelog = "https://github.com/sharkdp/pastel/releases/tag/v${version}";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ davidtwco ];
  };
}
