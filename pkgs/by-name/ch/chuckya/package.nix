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
    rev = "625e59bedbf82a66cd5200776c4b132a59fc151b";
    hash = "sha256-7IESuhmfEAfU/TxhfzJgwKw2uYjt3Uesiq5BNBzsAh4=";
  };
in

(mastodon.override {
  pname = "chuckya";
  version = "0-unstable-2026-10-29";

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
