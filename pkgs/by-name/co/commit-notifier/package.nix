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
  version = "0-unstable-2026-01-10";
  src = fetchFromGitHub {
    owner = "linyinfeng";
    repo = "commit-notifier";
    rev = "74d95c00f7922aa2032dee0016f3df4dfe2b3637";
    sha256 = "sha256-WZyWjom12nVYkCb+YrUhrCHLaZGJuOik0yrmreMNGj8=";
  };

  cargoHash = "sha256-z5t6JpSX7o3VI7DQIO65aBn5QajvtkeyAeWVDIThLh8=";

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
