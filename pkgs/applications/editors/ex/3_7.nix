{ pkgs, fetchurl, stdenv }:

import ./mk_ex.nix {
  pkgs = pkgs;
  fetchurl = fetchurl;
  stdenv   = stdenv;
  version  = "3.7";
  release  = "160713";
  hash     = "19d4vw5kwi651gk4l5nwd0h7a4hh66csn9m5qiblf11lbx9yfg3a";
  desc     = "The original vi (version 3.7 released in October 1981 on 4.1cBSD)";
}

