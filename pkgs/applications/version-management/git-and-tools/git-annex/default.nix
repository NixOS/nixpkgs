{ stdenv, fetchurl, curl, dataenc, findutils, ghc, git, hS3, hslogger, HTTP, hxt
, ikiwiki, json, libuuid, MissingH, monadControl, mtl, network, pcreLight, perl
, QuickCheck, rsync, SHA, testpack, utf8String, which, liftedBase, coreutils
, IfElse, bloomfilter, editDistance, openssh
}:

let
  version = "3.20120614";
in
stdenv.mkDerivation {
  name = "git-annex-${version}";

  src = fetchurl {
    url = "http://git.kitenet.net/?p=git-annex.git;a=snapshot;sf=tgz;h=refs/tags/${version}";
    sha256 = "ecb3b144a75a2eeb27061c46f3300c5117a5df260dddb36349eb8e75b6eebb16";
    name = "git-annex-${version}.tar.gz";
  };

  buildInputs = [
    curl dataenc findutils ghc git hS3 hslogger HTTP hxt ikiwiki json
    libuuid MissingH monadControl mtl network pcreLight perl QuickCheck
    rsync SHA testpack utf8String which liftedBase IfElse bloomfilter
    editDistance openssh
  ];

  checkTarget = "test";
  doCheck = true;

  # The 'add_url' test fails because it attempts to use the network.
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
