{ fetchurl, stdenv, glib, xorg, cairo, gtk2, pango, makeWrapper, openssl, bzip2,
  pkexecPath ? "/run/wrappers/bin/pkexec", libredirect,
  gksuSupport ? false, gksu, unzip, zip, bash }:

import ../common.nix {
  inherit fetchurl stdenv glib xorg cairo gtk2 pango makeWrapper openssl bzip2 pkexecPath libredirect gksuSupport gksu unzip zip bash;

  build = "3143";
  x32sha256 = "0dgpx4wij2m77f478p746qadavab172166bghxmj7fb61nvw9v5i";
  x64sha256 = "06b554d2cvpxc976rvh89ix3kqc7klnngvk070xrs8wbyb221qcw";
}
