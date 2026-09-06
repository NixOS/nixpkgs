{
  lib,
  fetchFromGitHub,
  applyPatches,
  mastodon,

  patches ? [ ],
  gemset ? ./gemset.nix,
  yarnMissingHashes ? ./missing-hashes.json,
  yarnHash ? "sha256-Wo5a8ESc0VTVMpWU12APvDLd4qG592rsA+m1HdjmGqI=",
}:

let
  src = applyPatches {
    src = fetchFromGitHub {
      owner = "TheEssem";
      repo = "mastodon";
      rev = "4cd56719f117375a0e4b21367dda2af3068a81d0";
      hash = "sha256-rDqMSfUqmuTPAX0/2bSLTzj60UQQ1KtF8yPLWgSjy/U=";
    };
    inherit patches;
  };
in

(mastodon.override {
  pname = "chuckya";
  version = "0-unstable-2026-08-26";

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
