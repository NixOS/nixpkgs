{ pkgs, fetchurl, stdenv }:

import ./mk_ex.nix {
  pkgs = pkgs;
  fetchurl = fetchurl;
  stdenv   = stdenv;
  version  = "3.6";
  release  = "160723";
  hash     = "1r3w299cgh176hqgd9g69lrwn4ci8dbqjiygf0k4g8hlx151lrp3";
  desc     = "vi version 3.6 (from 4.0BSD, November 1980)";
}

