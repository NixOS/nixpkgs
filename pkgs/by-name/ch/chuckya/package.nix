{
  lib,
  fetchFromGitHub,
  applyPatches,
  mastodon,

  patches ? [ ],
  gemset ? ./gemset.nix,
  yarnMissingHashes ? ./missing-hashes.json,
  yarnHash ? "sha256-1kdslAHO6goCo6GwU3zPpaN6Zx9nXEXuxF3E35Xzcac=",
}:

let
  src = applyPatches {
    src = fetchFromGitHub {
      owner = "TheEssem";
      repo = "mastodon";
      rev = "a7610aa2b86ffdcabc86008cca4234f135f642bd";
      hash = "sha256-c786uMkC0fEj3h4FKTGzz+GADUOfWCfTziLOCM0xWSI=";
    };
    inherit patches;
  };
in

(mastodon.override {
  pname = "chuckya";
  version = "0-unstable-2026-09-25";

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
