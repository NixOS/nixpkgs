{ stdenv, ghc, fetchurl, perl, coreutils, git, libuuid, rsync
, findutils, curl, ikiwiki, which, openssh
, blazeBuilder, blazeHtml, bloomfilter, caseInsensitive
, clientsession, cryptoApi, dataDefault, dataenc, dbus
, editDistance, extensibleExceptions, filepath, hamlet, hinotify
, hS3, hslogger, HTTP, httpTypes, IfElse, json, liftedBase
, MissingH, monadControl, mtl, network, networkInfo
, networkMulticast, pcreLight, QuickCheck, SHA, stm, text, time
, transformers, transformersBase, utf8String, wai, waiLogger, warp
, yesod, yesodDefault, yesodStatic, testpack, SafeSemaphore
, networkPprotocolXmpp, async, dns, DAV
}:

let
  version = "3.20121211";
in
stdenv.mkDerivation {
  name = "git-annex-${version}";

  src = fetchurl {
    url = "http://git.kitenet.net/?p=git-annex.git;a=snapshot;sf=tgz;h=${version}";
    sha256 = "1l5sffcn6mcfk0s808z490s30dbq8m4wi8a11ard35hyf599zawq";
    name = "git-annex-${version}.tar.gz";
  };

  buildInputs = [ ghc git libuuid rsync findutils curl ikiwiki which
    openssh blazeBuilder blazeHtml bloomfilter caseInsensitive
    clientsession cryptoApi dataDefault dataenc dbus editDistance
    extensibleExceptions filepath hamlet hinotify hS3 hslogger HTTP
    httpTypes IfElse json liftedBase MissingH monadControl mtl network
    networkInfo networkMulticast pcreLight QuickCheck SHA stm text time
    transformers transformersBase utf8String wai waiLogger warp yesod
    yesodDefault yesodStatic testpack SafeSemaphore networkPprotocolXmpp
    async dns DAV ];

  checkTarget = "test";
  doCheck = true;

  preConfigure = ''
    makeFlagsArray=( PREFIX=$out )
    sed -i -e 's|#!/usr/bin/perl|#!${perl}/bin/perl|' Build/mdwn2man
    sed -i -e 's|"cp |"${coreutils}/bin/cp |' -e 's|"rm -f |"${coreutils}/bin/rm -f |' test.hs
    # Remove this patch after the next update!
    sed -i -e '9i #define WITH_OLD_URI' Utility/Url.hs
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
