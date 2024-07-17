{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  sqlite,
  installShellFiles,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "flawz";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = "flawz";
    rev = "v${version}";
    hash = "sha256-/gNHi7ZENy0cgnEgDBW82ACUUsuMLYD9eUrSxwO9k1U=";
  };

  cargoHash = "sha256-kMiKlZj+G1vfjaEiB3rtPoJl0K3W9xRVwgVz8q2pn1s=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs = [
    openssl
    sqlite
  ];
  outputs = [
    "out"
    "man"
  ];

  postInstall = ''
    export OUT_DIR=$(mktemp -d)

    # Generate the man pages
    cargo run --bin flawz-mangen
    installManPage $OUT_DIR/flawz.1

    # Generate shell completions
    cargo run --bin flawz-completions
    installShellCompletion \
      --bash $OUT_DIR/flawz.bash \
      --fish $OUT_DIR/flawz.fish \
      --zsh $OUT_DIR/_flawz

    # Clean up temporary directory
    rm -rf $OUT_DIR
  '';

  meta = {
    description = "Terminal UI for browsing CVEs";
    homepage = "https://github.com/orhun/flawz";
    changelog = "https://github.com/orhun/flawz/releases/tag/v${version}";
    license = with lib.licenses; [
      mit
      asl20
    ];
    mainProgram = "flawz";
    maintainers = with lib.maintainers; [ anas ];
    platforms = with lib.platforms; unix ++ windows;
    broken = stdenv.isDarwin; # needing some apple_sdk packages
  };
}
