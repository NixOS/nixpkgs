{ pkgs, fetchurl, stdenv }:

import ./mk_ex.nix {
  pkgs = pkgs;
  fetchurl = fetchurl;
  stdenv   = stdenv;
  version  = "1.1";
  release  = "160706";
  hash     = "1lccx9zxl33bmra44yphgl0pa1f3ly8yvnmf2r2bdy99j252s636";
  desc     = "The very first version of the original vi (version 1.1 released on January 1, 1978 on 1BSD)";
}

