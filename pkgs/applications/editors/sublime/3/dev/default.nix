{ fetchurl, stdenv, glib, xorg, cairo, gtk2, pango, makeWrapper, openssl, bzip2,
  pkexecPath ? "/run/wrappers/bin/pkexec", libredirect,
  gksuSupport ? false, gksu, unzip, zip, bash }:

import ../common.nix {
  inherit fetchurl stdenv glib xorg cairo gtk2 pango makeWrapper openssl bzip2 pkexecPath libredirect gksuSupport gksu unzip zip bash;

  build = "3160";
  x32sha256 = "0vib7d6g47pxkr41isarig985l2msgal6ad9b9qx497aa8v031r5";
  x64sha256 = "0dy2w3crb1079w1n3pj37hy4qklvblrl742nrd3n4c7rzmzsg71b";
}
