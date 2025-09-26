{ fetchurl }:
let
  release = "vD0E6FC9F3A82C2E9";
  owner = "Nexus-Mods";
  repo = "game-hashes";
  repoURL = "https://github.com/${owner}/${repo}";

  # Define a binding so that `update-source-version` can find it
  src = fetchurl {
    url = "${repoURL}/releases/download/${release}/game_hashes_db.zip";
    hash = "sha256-ACwhWSoxe1CxBWhkgixZeLKpfdXAnavd/30ELInVtZM=";
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
