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
    rev = "dc850e2434c3de2396b869d910193f8d3587ce73";
    hash = "sha256-Mgc/48YTewqEr7gjqTxT3EDIWHl3qDXEVzOWTZXrDp4=";
  };
in

(mastodon.override {
  pname = "chuckya";
  version = "0-unstable-2026-11-06";

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
