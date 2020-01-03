{ rustPlatform, lib, fetchFromGitHub, ncurses, openssl, pkgconfig, Security, stdenv }:

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
  nativeBuildInputs = [ pkgconfig ];

  cargoSha256 = "0h8ybhb17pqhhfjcmq1l70kp8g1yyq38228lcf86byk3r2ar2rkg";

  meta = with lib; {
    homepage = https://crates.io/crates/taizen;
    license = licenses.mit;
    description = "curses based mediawiki browser";
    maintainers = with maintainers; [ ma27 ];
  };
}
