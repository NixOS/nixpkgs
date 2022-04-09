{ lib, fetchurl, callPackage }:

callPackage (import ./common.nix rec {
  pname = "cgit-pink";
  version = "1.3.0";

  src = fetchurl {
    url = "https://git.causal.agency/cgit-pink/snapshot/cgit-pink-${version}.tar.gz";
    sha256 = "sha256-oL46NWgqi1VqKNEt0QGBWNXbi2l7nOQDZy1aMivcWuM=";
  };

  # cgit-pink is tightly coupled with git and needs a git source tree to build.
  # IMPORTANT: Remember to check which git version cgit-pink needs on every
  # version bump (look for "GIT_VER" in the top-level Makefile).
  gitSrc = fetchurl {
    url    = "mirror://kernel/software/scm/git/git-2.35.1.tar.xz";
    sha256 = "sha256-12hSjmRD9logMDYmbxylD50Se6iXUeMurTcRftkZEIA=";
  };

  homepage = "https://git.causal.agency/cgit-pink/about/";
  description = "cgit fork aiming for better maintenance";
  maintainers = with lib.maintainers; [ qyliss sternenseemann ];
}) {}
