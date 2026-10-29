{
  lib,
  fetchFromGitHub,
  applyPatches,
  mastodon,

  patches ? [ ],
  gemset ? ./gemset.nix,
  yarnMissingHashes ? ./missing-hashes.json,
  yarnHash ? "sha256-9gHfbjasIpXiOr7lbRV7Na7cu2mDXUXvkV6rTljTAvM=",
}:

let
  src = fetchFromGitHub {
    owner = "TheEssem";
    repo = "mastodon";
    rev = "63d369283df5c4cffb09d3dc6fd38f5b41a1e2ef";
    hash = "sha256-tr9c9sDO99Mz8uVlx0NsvFPHYDBRq+9BmoXksq5/1fE=";
  };
in

(mastodon.override {
  pname = "chuckya";
  version = "0-unstable-2026-10-10";

  srcOverride = applyPatches { inherit src patches; };

  inherit gemset yarnMissingHashes yarnHash;
}).overrideAttrs
  {
    passthru = {
      updateScript = ./update.sh;

      # needed for nix-update
      inherit src;
    };

    meta = {
      description = "Close-to-upstream soft fork of Mastodon Glitch Edition";
      homepage = "https://github.com/TheEssem/mastodon";
      license = lib.licenses.agpl3Plus;
      maintainers = with lib.maintainers; [ defelo ];
    };
  }
