{ stdenv, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "pastel";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "sharkdp";
    repo = pname;
    rev = "v${version}";
    sha256 = "1c47bph1qraq3g0g5bp23jqlz7qdn4f8vh264y937jz17avvacx5";
  };

  cargoSha256 = "1hkqahsrhmgcpgp0pvfpc0wmwqivnqylsxzjrz63k1s9ssdv9syy";

  buildInputs = stdenv.lib.optional stdenv.isDarwin Security;

  meta = with stdenv.lib; {
    description = "A command-line tool to generate, analyze, convert and manipulate colors";
    homepage = https://github.com/sharkdp/pastel;
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ davidtwco ];
    platforms = platforms.all;
  };
}
