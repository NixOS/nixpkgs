{ stdenv, attemptoClex, callPackage }:

callPackage ./. {
  pname = "ape-clex";
  lexiconPath = "${attemptoClex}/clex_lexicon.pl";
  description = "Parser for Attempto Controlled English (ACE) with a large lexicon (~100,000 entries)";
  license = with stdenv.lib; [ licenses.lgpl3 licenses.gpl3 ];
}
