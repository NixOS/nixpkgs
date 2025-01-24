{
  lib,
  stdenv,
  fetchFromGitLab,
  rustPlatform,
  pkg-config,
  # libgit2,
  openssl,
  sqlite,
  libiconv,
  Security,
}:

rustPlatform.buildRustPackage rec {
  pname = "terminal-typeracer";
  version = "2.1.5";

  src = fetchFromGitLab {
    owner = "ttyperacer";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-7LKpOO+PVGGtFJh1dZW/n/zovTxxZbb2VQwzgmjZhIY=";
  };

  cargoHash = "sha256-SpuZk/o25UpZcgRp4UueexAqvtRgzCN7JYW5Yj9w+0U=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs =
    [
      openssl
      sqlite
      # libgit2
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      libiconv
      Security
    ];

  OPENSSL_NO_VENDOR = 1;
  LIBGIT2_NO_VENDOR = 0; # FIXME

  meta = with lib; {
    description = "Open source terminal based version of Typeracer written in rust";
    homepage = "https://gitlab.com/ttyperacer/terminal-typeracer";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ yoctocell ];
    mainProgram = "typeracer";
    platforms = platforms.unix;
  };
}
