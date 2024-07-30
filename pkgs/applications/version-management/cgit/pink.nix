{ lib, fetchurl, callPackage }:

callPackage (import ./common.nix rec {
  pname = "cgit-pink";
  version = "1.4.1";

  src = fetchurl {
    url = "https://git.causal.agency/cgit-pink/snapshot/cgit-pink-${version}.tar.gz";
    sha256 = "1ma6j3r4ba5fhd47pc6xn5bmxaqr8ci2pvky9v100n1hh5n6q97i";
  };

  # cgit-pink is tightly coupled with git and needs a git source tree to build.
  # IMPORTANT: Remember to check which git version cgit-pink needs on every
  # version bump (look for "GIT_VER" in the top-level Makefile).
  gitSrc = fetchurl {
    url    = "mirror://kernel/software/scm/git/git-2.36.1.tar.xz";
    sha256 = "0w43a35mhc2qf2gjkxjlnkf2lq8g0snf34iy5gqx2678yq7llpa0";
  };

  homepage = "https://git.causal.agency/cgit-pink/about/";
  description = "cgit fork aiming for better maintenance";
  maintainers = with lib.maintainers; [ sternenseemann ];
}) {}
