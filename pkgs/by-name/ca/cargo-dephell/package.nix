{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  stdenv,
  curl,
  openssl,
  libgit2,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-dephell";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "mimoo";
    repo = "cargo-dephell";
    rev = "v${version}";
    hash = "sha256-NOjkKttA+mwPCpl4uiRIYD58DlMomVFpwnM9KGfWd+w=";
  };

  cargoPatches = [
    # update Cargo.lock to work with openssl 3
    ./openssl3-support.patch
  ];

  cargoHash = "sha256-+5ElAfYuUfosXzR3O2QIFGy4QJuPrWDMg5LacZKi3c8=";

  nativeBuildInputs = [
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    curl
  ];

  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    curl
    libgit2
  ];

  env = {
    LIBGIT2_NO_VENDOR = 1;
  };

  meta = with lib; {
    description = "Tool to analyze the third-party dependencies imported by a rust crate or rust workspace";
    mainProgram = "cargo-dephell";
    homepage = "https://github.com/mimoo/cargo-dephell";
    license = with licenses; [
      mit # or
      asl20
    ];
    maintainers = with maintainers; [
      figsoda
      matthiasbeyer
    ];
  };
}
