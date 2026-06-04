{
  lib,
  attemptoClex,
  callPackage,
}:

callPackage ./package.nix {
  pname = "ape-clex";
  lexiconPath = "${attemptoClex}/clex_lexicon.pl";
  description = "Parser for Attempto Controlled English (ACE) with a large lexicon (~100,000 entries)";
  license = with lib.licenses; [
    lgpl3
    gpl3
  ];
}
