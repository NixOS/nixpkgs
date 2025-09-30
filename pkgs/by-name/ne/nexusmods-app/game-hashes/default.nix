{ fetchurl }:
let
  release = "v1a75cea1c1f2efc6";
  owner = "Nexus-Mods";
  repo = "game-hashes";
  repoURL = "https://github.com/${owner}/${repo}";

  # Define a binding so that `update-source-version` can find it
  src = fetchurl {
    url = "${repoURL}/releases/download/${release}/game_hashes_db.zip";
    hash = "sha256-LvVOp4vbLwae0CM0CukFoXeNRn0FKXjIhHgbxYwnGnI=";
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
