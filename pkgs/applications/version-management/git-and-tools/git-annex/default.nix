{ stdenv, fetchurl, ghc, libuuid, rsync, findutils, curl, perl, MissingH, utf8String, QuickCheck2, pcreLight, SHA, dataenc }:

let
  version = "0.20110427";
in
stdenv.mkDerivation {
  name = "git-annex-${version}";

  src = fetchurl {
    url = "http://ftp.de.debian.org/debian/pool/main/g/git-annex/git-annex_${version}.tar.gz";
    sha256 = "1vbmkvf9hlnfcaqsyi1ay2rr835j49bxqyfdi3v3373pdfd6195z";
  };

  buildInputs = [ghc libuuid rsync findutils curl perl MissingH utf8String QuickCheck2 pcreLight SHA dataenc];

  preConfigure = ''
    makeFlagsArray=( PREFIX=$out )
    sed -i -e 's|#!/usr/bin/perl|#!${perl}/bin/perl|' mdwn2man
  '';

  meta = {
    description = "Manage files with git, without checking the file contents into git";

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

    license = "GPLv3+";
    homepage = "http://git-annex.branchable.com/";
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
