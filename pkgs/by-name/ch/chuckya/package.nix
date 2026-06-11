{
  lib,
  fetchFromGitHub,
  applyPatches,
  mastodon,

  patches ? [ ],
  gemset ? ./gemset.nix,
  yarnMissingHashes ? ./missing-hashes.json,
  yarnHash ? "sha256-FCcCTHOGQ58J39/rkg/3rznlxFc4Jr5tsOBptdHffU8=",
}:

let
  src = applyPatches {
    src = fetchFromGitHub {
      owner = "TheEssem";
      repo = "mastodon";
      rev = "5ce996d5d3057eb27560abbdf28bf987d9524529";
      hash = "sha256-L8rlURQkRWk1GIzP+00TNYwPbf27Bwgjd0GGMsiZWMY=";
    };
    inherit patches;
  };
in

(mastodon.override {
  pname = "chuckya";
  version = "0-unstable-2026-06-27";

  srcOverride = src;

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
