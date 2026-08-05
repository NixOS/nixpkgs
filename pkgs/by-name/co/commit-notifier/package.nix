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
  version = "0-unstable-2026-05-31";
  src = fetchFromGitHub {
    owner = "linyinfeng";
    repo = "commit-notifier";
    rev = "82d9177bc494f946d5fcdae14578908b5b7fb2f5";
    hash = "sha256-tlYXx9gtHv3HSlmdtGIZ70CsL19nmhoi8DbzQu30izQ=";
  };

  cargoHash = "sha256-VOemLMuCa1AEwbFnngimO9xtpi/ZGcX6ZstwKEaOdvA=";

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
