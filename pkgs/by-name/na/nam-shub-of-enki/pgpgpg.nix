{ rustPlatform, fetchFromForgejo }:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pgpgpg";
  version = "0-unstable-2026-05-27";

  __structuredAttrs = true;

  src = fetchFromForgejo {
    domain = "git.madhouse-project.org";
    owner = "algernon";
    repo = "pgpgpg";
    rev = "84da504e55c4860a7d72b2c121b7a0ecc5b118ca";
    hash = "sha256-FSbxmuFerb6hs24Ety1/YCQd876oDe4wo3Fbjh3Mcoo=";
  };

  cargoHash = "sha256-Askh1l/tt32JoWuwjE3vKy1/5q20v/5B/PlPQTTX2pA=";
})
