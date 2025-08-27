{ fetchurl }:
let
  release = "ved4b249e2c35952c";
  owner = "Nexus-Mods";
  repo = "game-hashes";
  repoURL = "https://github.com/${owner}/${repo}";

  # Define a binding so that `update-source-version` can find it
  src = fetchurl {
    url = "${repoURL}/releases/download/${release}/game_hashes_db.zip";
    hash = "sha256-9xJ8yfLRkIV0o++NHK2igd2l83/tsgWc5cuwZO2zseY=";
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
