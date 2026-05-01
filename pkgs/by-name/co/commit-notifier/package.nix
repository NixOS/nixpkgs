{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  sqlite,
  libgit2,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "commit-notifier";
  version = "0-unstable-2026-02-07";
  src = fetchFromGitHub {
    owner = "linyinfeng";
    repo = "commit-notifier";
    rev = "93ad526940c60d3a7be65239e6ff8604ce8c6e17";
    hash = "sha256-2U1Pp6v68fAxG6pVztHvCGe8FP714o9V2WQFMSmChBQ=";
  };

  cargoHash = "sha256-IezbCVH3C7i7COZ8Fw7aXym7Q64hy6jxo98aohxgOyA=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    sqlite
    libgit2
    openssl
  ];

  meta = {
    description = "Simple telegram bot monitoring commit status";
    homepage = "https://github.com/linyinfeng/commit-notifier";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      mlyxshi
    ];
    platforms = lib.platforms.linux;
    mainProgram = "commit-notifier";
  };
})
