{ lib
, stdenv
, fetchFromGitLab
, rustPlatform
, pkg-config
, libgit2
, openssl
, sqlite
, libiconv
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "terminal-typeracer";
  version = "2.1.3";

  src = fetchFromGitLab {
    owner = "ttyperacer";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-S3OW6KihRd6ReTWUXRb1OWC7+YoxehjFRBxcnJVgImU=";
  };

  cargoHash = "sha256-OwbFIbKB/arj+3gq2tfEq8yTKSUPBQNYJNzrWvDv4A4=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libgit2 openssl sqlite ] ++ lib.optionals stdenv.isDarwin [ libiconv Security ];

  OPENSSL_NO_VENDOR = 1;
  LIBGIT2_NO_VENDOR = 1;

  meta = with lib; {
    description = "An open source terminal based version of Typeracer written in rust";
    homepage = "https://gitlab.com/ttyperacer/terminal-typeracer";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ yoctocell ];
    mainProgram = "typeracer";
    platforms = platforms.unix;
  };
}
