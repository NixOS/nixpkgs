{ pkgs, fetchurl, stdenv }:

import ./mk_ex.nix {
  pkgs = pkgs;
  fetchurl = fetchurl;
  stdenv   = stdenv;
  version  = "2.2";
  release  = "160715";
  hash     = "1afrj2ga03a7i3m1zkxkj3jsa2n6bs8smlpbzj67vdjzfi63wq91";
  desc     = "vi version 2.2 (from 2BSD, May 1979)";
}


