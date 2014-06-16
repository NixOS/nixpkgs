{ cabal, aeson, async, blazeBuilder, bloomfilter, bup, byteable
, caseInsensitive, clientsession, cryptoApi, cryptohash, curl
, dataDefault, dataenc, DAV, dbus, dlist, dns, editDistance
, exceptions, extensibleExceptions, fdoNotify, feed, filepath, git
, gnupg1, gnutls, hamlet, hinotify, hS3, hslogger, HTTP, httpClient
, httpConduit, httpTypes, IfElse, json, liftedBase, lsof, MissingH
, monadControl, mtl, network, networkConduit, networkInfo
, networkMulticast, networkProtocolXmpp, openssh
, optparseApplicative, perl, QuickCheck, random, regexTdfa, rsync
, SafeSemaphore, securemem, SHA, shakespeare, stm, tasty
, tastyHunit, tastyQuickcheck, tastyRerun, text, time, transformers
, unixCompat, utf8String, uuid, wai, waiExtra, warp, warpTls, which
, xmlTypes, yesod, yesodCore, yesodDefault, yesodForm, yesodStatic
}:

cabal.mkDerivation (self: {
  pname = "git-annex";
  version = "5.20140613";
  sha256 = "01khqy68w1rqxic9lqal7902cv89d10xvbzmvlsx99g70ljqfafi";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    aeson async blazeBuilder bloomfilter byteable caseInsensitive
    clientsession cryptoApi cryptohash dataDefault dataenc DAV dbus
    dlist dns editDistance exceptions extensibleExceptions fdoNotify
    feed filepath gnutls hamlet hinotify hS3 hslogger HTTP httpClient
    httpConduit httpTypes IfElse json liftedBase MissingH monadControl
    mtl network networkConduit networkInfo networkMulticast
    networkProtocolXmpp optparseApplicative QuickCheck random regexTdfa
    SafeSemaphore securemem SHA shakespeare stm tasty tastyHunit
    tastyQuickcheck tastyRerun text time transformers unixCompat
    utf8String uuid wai waiExtra warp warpTls xmlTypes yesod yesodCore
    yesodDefault yesodForm yesodStatic
  ];
  buildTools = [ bup curl git gnupg1 lsof openssh perl rsync which ];
  configureFlags = "-fS3
                    -fWebDAV
                    -fInotify
                    -fDbus
                    -fAssistant
                    -fWebapp
                    -fPairing
                    -fXMPP
                    -fDNS
                    -fProduction
                    -fTDFA";
  preConfigure = ''
    export HOME="$NIX_BUILD_TOP/tmp"
    mkdir "$HOME"
  '';
  installPhase = "./Setup install";
  checkPhase = ''
    cp dist/build/git-annex/git-annex git-annex
    ./git-annex test
  '';
  propagatedUserEnvPkgs = [git lsof];
  meta = {
    homepage = "http://git-annex.branchable.com/";
    description = "manage files with git, without checking their contents into git";
    license = self.stdenv.lib.licenses.gpl3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.simons ];
  };
})
