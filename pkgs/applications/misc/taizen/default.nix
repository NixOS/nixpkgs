{ rustPlatform, lib, fetchFromGitHub, ncurses, openssl, pkg-config, Security, stdenv }:

rustPlatform.buildRustPackage rec {
  pname = "taizen";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "NerdyPepper";
    repo = pname;
    rev = "5c1876429e2da7424e9d31b1e16f5a3147cc58d0";
    sha256 = "09izgx7icvizskdy9kplk0am61p7550fsd0v42zcihq2vap2j92z";
  };

  buildInputs = [ ncurses openssl ] ++ lib.optional stdenv.isDarwin Security;
  nativeBuildInputs = [ pkg-config ];

  cargoSha256 = "0wbzr0rdqpdbqi1k5v39py62ivlglhvif3b8rvr8xk61w91jk6x2";

  meta = with lib; {
    homepage = "https://crates.io/crates/taizen";
    license = licenses.mit;
    description = "curses based mediawiki browser";
    maintainers = with maintainers; [ ma27 ];
  };
}
