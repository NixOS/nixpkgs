{ stdenv, fetchurl, perl, which, ikiwiki, ghc, aeson, async, blazeBuilder
, bloomfilter, bup, caseInsensitive, clientsession, cryptoApi, curl, dataDefault
, dataenc, DAV, dbus, dns, editDistance, extensibleExceptions, filepath, git
, gnupg1, gnutls, hamlet, hinotify, hS3, hslogger, httpConduit, httpTypes, HUnit
, IfElse, json, liftedBase, lsof, MissingH, monadControl, mtl, network
, networkInfo, networkMulticast, networkProtocolXmpp, openssh, QuickCheck
, random, regexCompat, rsync, SafeSemaphore, SHA, stm, text, time, transformers
, transformersBase, utf8String, uuid, wai, waiLogger, warp, xmlConduit, xmlTypes
, yesod, yesodDefault, yesodForm, yesodStatic, testpack
, cabalInstall		# TODO: remove this build input at the next update
}:

let
  version = "4.20130227";
in
stdenv.mkDerivation {
  name = "git-annex-${version}";

  src = fetchurl {
    url = "http://git.kitenet.net/?p=git-annex.git;a=snapshot;sf=tgz;h=${version}";
    sha256 = "1zw5kzb08zz43ahbhrazjpq9zn73l3kwnqilp464frf7fg7rwan6";
    name = "git-annex-${version}.tar.gz";
  };

  buildInputs = [ ghc aeson async blazeBuilder bloomfilter bup ikiwiki
    caseInsensitive clientsession cryptoApi curl dataDefault dataenc DAV dbus
    dns editDistance extensibleExceptions filepath git gnupg1 gnutls hamlet
    hinotify hS3 hslogger httpConduit httpTypes HUnit IfElse json liftedBase
    lsof MissingH monadControl mtl network networkInfo networkMulticast
    networkProtocolXmpp openssh QuickCheck random regexCompat rsync
    SafeSemaphore SHA stm text time transformers transformersBase utf8String
    uuid wai waiLogger warp xmlConduit xmlTypes yesod yesodDefault yesodForm
    yesodStatic which perl testpack cabalInstall ];

  configurePhase = ''
    makeFlagsArray=( PREFIX=$out )
    patchShebangs .

    # cabal-install wants to store stuff in $HOME
    mkdir ../tmp
    export HOME=$PWD/../tmp

    cabal configure -f-fast -ftestsuite -f-android -fproduction -fdns -fxmpp -fpairing -fwebapp -fassistant -fdbus -finotify -fwebdav -fs3
  '';

  checkPhase = "./git-annex test";

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
