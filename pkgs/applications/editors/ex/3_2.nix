{ pkgs, fetchurl, stdenv }:

import ./mk_ex.nix {
  pkgs = pkgs;
  fetchurl = fetchurl;
  stdenv   = stdenv;
  version  = "3.2";
  release  = "160719";
  hash     = "0c7an0001pmzw7xhhpwzy58wk1c26nq5vwxg8xjz932piwgn3dlc";
  desc     = "vi version 3.2 (from 3BSD, January 1980)";
}

