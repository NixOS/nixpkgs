{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "edamame";
  version = "0.1.2";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "mijowi";
    repo = "edamame";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZLnp2ej2E3+qg2LOPPZundT+XsgYR4EbhYd7uqCWab8=";
  };

  cargoHash = "sha256-O/cFL8yRvCnQUBlmooveChD5RiSbU6gbFGSxeQctLGs=";

  # The watcher tests need live inotify/FSEvents notifications, which the Nix
  # build sandbox doesn't deliver — on Darwin builders not at all.  Both skips
  # are needed: the second test's name does not contain "watcher", so the
  # first pattern misses it.  Everything else runs offline fine.
  checkFlags = [
    "--skip=watcher"
    "--skip=rewatching_a_different_file_redirects_events"
  ];

  meta = {
    description = "Fast TUI Markdown editor and viewer";
    homepage = "https://github.com/mijowi/edamame";
    changelog = "https://github.com/mijowi/edamame/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mijowi ];
    mainProgram = "edamame";
    platforms = lib.platforms.unix; # dist ships macOS + Linux, no Windows
  };
})
