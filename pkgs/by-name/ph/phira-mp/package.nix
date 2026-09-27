{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "phira-mp";
  # 0.1.0 does not build because the time crate is too old and is incompatible with Rust 1.80.0 or later.
  version = "0.1.0-unstable-2025-06-10";

  src = fetchFromGitHub {
    owner = "TeamFlos";
    repo = "phira-mp";
    rev = "30b481117af8d17cbfcca88de460e4a407a4cb67";
    hash = "sha256-oKQbym627+7ghD7LRI0PaYWzqIm8PinjmUgqlkvDKRA=";
  };

  nativeBuildInputs = [ pkg-config ];

  cargoHash = "sha256-fkGB9qgOxroOjfQMwXfJqSVWB1S7T+ndYVYEmGrqtIs=";

  buildInputs = [ openssl ];

  meta = {
    description = "Multiplayer server for the rhythm game Phira";
    homepage = "https://github.com/TeamFlos/phira-mp";
    maintainers = with lib.maintainers; [ ulysseszhan ];
    license = lib.licenses.unfree; # https://github.com/TeamFlos/phira-mp/issues/7
    platforms = lib.platforms.unix;
    mainProgram = "phira-mp-server";
  };

})
