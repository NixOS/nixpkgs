{ lib, fetchurl, callPackage, luajit, nixosTests }:

callPackage (import ./common.nix rec {
  pname = "cgit";
  version = "1.2.3";

  src = fetchurl {
    url = "https://git.zx2c4.com/cgit/snapshot/${pname}-${version}.tar.xz";
    sha256 = "193d990ym10qlslk0p8mjwp2j6rhqa7fq0y1iff65lvbyv914pss";
  };

  # cgit is tightly coupled with git and needs a git source tree to build.
  # IMPORTANT: Remember to check which git version cgit needs on every version
  # bump (look for "GIT_VER" in the top-level Makefile).
  gitSrc = fetchurl {
    url    = "mirror://kernel/software/scm/git/git-2.25.1.tar.xz";
    sha256 = "09lzwa183nblr6l8ib35g2xrjf9wm9yhk3szfvyzkwivdv69c9r2";
  };

  buildInputs = [ luajit ];

  passthru.tests = { inherit (nixosTests) cgit; };

  homepage = "https://git.zx2c4.com/cgit/about/";
  description = "Web frontend for git repositories";
  maintainers = with lib.maintainers; [ bjornfor ];
}) {}
