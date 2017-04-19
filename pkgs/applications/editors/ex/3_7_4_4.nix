{ pkgs, fetchurl, stdenv }:

import ./mk_ex.nix {
  pkgs = pkgs;
  fetchurl = fetchurl;
  stdenv   = stdenv;
  version  = "3.7_4.4BSD";
  release  = "160705";
  hash     = "1aj8c4ym8d49p9n851zbda3bw3ym1mgyjilz37bpk3jn2lmikj51";
  desc     = "The final release of the original vi";
}

