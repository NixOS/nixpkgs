{ fetchurl }:
let
  release = "vc2e27b8bf8632dca";
  owner = "Nexus-Mods";
  repo = "game-hashes";
  repoURL = "https://github.com/${owner}/${repo}";

  # Define a binding so that `update-source-version` can find it
  src = fetchurl {
    url = "${repoURL}/releases/download/${release}/game_hashes_db.zip";
    hash = "sha256-lu/C/WkjXtGJuZrsTg9fc/aEyJSsj9unjz1Sym39/b8=";
    passthru = {
      inherit
        src # Also for `update-source-version` support
        release
        owner
        repo
        repoURL
        ;
    };
  };
in
src
