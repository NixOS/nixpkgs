{ stdenv, fetchurl, curl, dataenc, findutils, ghc, git, hS3, hslogger, HTTP, hxt
, ikiwiki, json, libuuid, MissingH, monadControl, mtl, network, pcreLight, perl
, QuickCheck2, rsync, SHA, testpack, utf8String, which, liftedBase, coreutils
}:

let
  version = "3.20120116";
in
stdenv.mkDerivation {
  name = "git-annex-${version}";

  src = fetchurl {
    url = "http://ftp.de.debian.org/debian/pool/main/g/git-annex/git-annex_${version}.tar.gz";
    sha256 = "7a6d7d12829f5ca750235b3e8a7c67b8edbfdbdc88002eaa2424c5f9d84e17e1";
  };

  buildInputs = [
    curl dataenc findutils ghc git hS3 hslogger HTTP hxt ikiwiki json
    libuuid MissingH monadControl mtl network pcreLight perl QuickCheck2
    rsync SHA testpack utf8String which liftedBase
  ];

  checkTarget = "test";
  doCheck = true;

  preConfigure = ''
    makeFlagsArray=( PREFIX=$out )
    sed -i -e 's|#!/usr/bin/perl|#!${perl}/bin/perl|' mdwn2man
    sed -i -e 's|"cp |"${coreutils}/bin/cp |' -e 's|"rm -f |"${coreutils}/bin/rm -f |' test.hs
  '';

  meta = {
    homepage = "http://git-annex.branchable.com/";
    description = "Manage files with git without checking them into git";
    license = stdenv.lib.licenses.gpl3Plus;

    longDescription = ''
      Git-annex allows managing files with git, without checking the
      file contents into git. While that may seem paradoxical, it is
      useful when dealing with files larger than git can currently
      easily handle, whether due to limitations in memory, checksumming
      time, or disk space.

      Even without file content tracking, being able to manage files
      with git, move files around and delete files with versioned
      directory trees, and use branches and distributed clones, are all
      very handy reasons to use git. And annexed files can co-exist in
      the same git repository with regularly versioned files, which is
      convenient for maintaining documents, Makefiles, etc that are
      associated with annexed files but that benefit from full revision
      control.
    '';

    platforms = ghc.meta.platforms;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
