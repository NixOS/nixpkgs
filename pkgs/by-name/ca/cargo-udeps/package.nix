{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  libiconv,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-udeps";
  version = "0.1.59";

  src = fetchFromGitHub {
    owner = "est31";
    repo = "cargo-udeps";
    rev = "v${version}";
    sha256 = "sha256-oA/oWXTaQPY7bCBUP52b+PACZXV+32G3/STh+sec6AI=";
  };

  cargoHash = "sha256-X+Y2ialZnwusy3XVnXiTcGmSYsKsFOmEOL4Gc5SgXWU=";

  nativeBuildInputs = [ pkg-config ];

  # TODO figure out how to use provided curl instead of compiling curl from curl-sys
  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  # Requires network access
  doCheck = false;

  meta = with lib; {
    description = "Find unused dependencies in Cargo.toml";
    homepage = "https://github.com/est31/cargo-udeps";
    license = licenses.mit;
    maintainers = with maintainers; [
      b4dm4n
      matthiasbeyer
    ];
    mainProgram = "cargo-udeps";
  };
}
