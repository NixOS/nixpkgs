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
  version = "2.0.8";

  src = fetchFromGitLab {
    owner = "ttyperacer";
    repo = pname;
    rev = "v${version}";
    sha256 = "Fb2MCQaQaJseXa8Csesz1s5Yel4wcSMxfMeKSW7rlU4=";
  };

  cargoSha256 = "sha256-SAVDSUm2jpDwTfwo4L6MVUKzBxZvCfjn4UNIGUJziSY=";

  buildInputs = [ openssl sqlite ] ++ lib.optionals stdenv.isDarwin [ libiconv Security ];
  nativeBuildInputs = [ pkg-config ];

  meta = with lib; {
    description = "An open source terminal based version of Typeracer written in rust";
    homepage = "https://gitlab.com/ttyperacer/terminal-typeracer";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ yoctocell ];
    mainProgram = "typeracer";
    platforms = platforms.unix;
  };
}
