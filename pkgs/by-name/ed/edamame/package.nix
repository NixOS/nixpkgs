{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "edamame";
  version = "0.1.6";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "mijowi";
    repo = "edamame";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0Ru2bo9flr1RDQ+wld3+cMNYyMc2zFP1HN/AK8MzHuc=";
  };

  cargoHash = "sha256-fW64rRP89nKHGoFp0z9NJSDIxO2XgWPeMeNWu95q9Rw=";

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
