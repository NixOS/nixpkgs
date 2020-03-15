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

  cargoSha256 = "0chrgwm97y1a3gj218x25yqk1y1h74a6gzyxjdm023msvs58nkni";

  meta = with lib; {
    homepage = https://crates.io/crates/taizen;
    license = licenses.mit;
    description = "curses based mediawiki browser";
    maintainers = with maintainers; [ ma27 ];
  };
}
