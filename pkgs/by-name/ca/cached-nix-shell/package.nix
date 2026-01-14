{
  fetchFromGitHub,
  lib,
  nix,
  ronn,
  rustPlatform,
}:

let
  blake3-src = fetchFromGitHub {
    owner = "BLAKE3-team";
    repo = "BLAKE3";
    rev = "refs/tags/1.5.1";
    hash = "sha256-STWAnJjKrtb2Xyj6i1ACwxX/gTkQo5jUHilcqcgJYxc=";
  };
in
rustPlatform.buildRustPackage rec {
  pname = "cached-nix-shell";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "xzfc";
    repo = "cached-nix-shell";
    rev = "refs/tags/v${version}";
    hash = "sha256-LI/hecqeRg3eCzU2bASJA8VoG4nvrSeHSeaGYn7M/UI=";
  };

  cargoHash = "sha256-Rl+PgNr29OAl6P/iUfkuFlQycyeYNmxUIIdigk7PgV4=";

  nativeBuildInputs = [
    nix
    ronn
  ];

  # The BLAKE3 C library is intended to be built by the project depending on it
  # rather than as a standalone library.
  # https://github.com/BLAKE3-team/BLAKE3/blob/0.3.1/c/README.md#building
  env.BLAKE3_CSRC = "${blake3-src}/c";

  postBuild = ''
    make -f nix/Makefile post-build
  '';

  postInstall = ''
    make -f nix/Makefile post-install
  '';

  meta = {
    description = "Instant startup time for nix-shell";
    mainProgram = "cached-nix-shell";
    homepage = "https://github.com/xzfc/cached-nix-shell";
    changelog = "https://github.com/xzfc/cached-nix-shell/releases/tag/v${version}";
    license = with lib.licenses; [
      unlicense
      # or
      mit
    ];
    maintainers = with lib.maintainers; [ xzfc ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
