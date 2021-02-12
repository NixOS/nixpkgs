{ lib, stdenv
, fetchFromGitLab
, rustPlatform
, pkg-config
, openssl
, sqlite
, libiconv
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "terminal-typeracer";
  version = "2.0.4";

  src = fetchFromGitLab {
    owner = "ttyperacer";
    repo = pname;
    rev = "v${version}";
    sha256 = "RjGHY6KN6thxbg9W5FRwaAmUeD+5/WCeMCvzFHqZ+J4=";
  };

  cargoSha256 = "T9uomh4nv0kyFxX+8NADkVmLB5MUOZofTYk1mmZP+p8=";

  buildInputs = [ openssl sqlite ] ++ lib.optionals stdenv.isDarwin [ libiconv Security ];
  nativeBuildInputs = [ pkg-config ];

  meta = with lib; {
    description = "An open source terminal based version of Typeracer written in rust";
    homepage = "https://gitlab.com/ttyperacer/terminal-typeracer";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ yoctocell ];
    platforms = platforms.x86_64;
  };
}
