{ cabal, aeson, async, blazeBuilder, bloomfilter, bup
, caseInsensitive, clientsession, cryptoApi, curl, dataDefault
, dataenc, DAV, dbus, dlist, dns, editDistance
, extensibleExceptions, filepath, git, gnupg1, gnutls, hamlet
, hinotify, hS3, hslogger, HTTP, httpConduit, httpTypes, HUnit
, IfElse, json, lsof, MissingH, MonadCatchIOTransformers
, monadControl, mtl, network, networkInfo, networkMulticast
, networkProtocolXmpp, openssh, QuickCheck, random, regexTdfa
, rsync, SafeSemaphore, SHA, stm, text, time, transformers
, unixCompat, utf8String, uuid, wai, waiLogger, warp, which
, xmlConduit, xmlTypes, yesod, yesodCore, yesodDefault, yesodForm
, yesodStatic
}:

cabal.mkDerivation (self: {
  pname = "git-annex";
  version = "4.20130627";
  sha256 = "1q9hdh7m04idx1nm631624s37p6w1b9j1z5n06j2449b3pxqrn3y";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    aeson async blazeBuilder bloomfilter caseInsensitive clientsession
    cryptoApi dataDefault dataenc DAV dbus dlist dns editDistance
    extensibleExceptions filepath gnutls hamlet hinotify hS3 hslogger
    HTTP httpConduit httpTypes HUnit IfElse json MissingH
    MonadCatchIOTransformers monadControl mtl network networkInfo
    networkMulticast networkProtocolXmpp QuickCheck random regexTdfa
    SafeSemaphore SHA stm text time transformers unixCompat utf8String
    uuid wai waiLogger warp xmlConduit xmlTypes yesod yesodCore
    yesodDefault yesodForm yesodStatic
  ];
  buildTools = [ bup curl git gnupg1 lsof openssh rsync which ];
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
  preConfigure = "patchShebangs .";
  installPhase = "make PREFIX=$out CABAL=./Setup docs install";
  checkPhase = ''
    export HOME="$NIX_BUILD_TOP/tmp"
    mkdir "$HOME"
    cp dist/build/git-annex/git-annex git-annex
    ./git-annex test
  '';
  meta = {
    homepage = "http://git-annex.branchable.com/";
    description = "manage files with git, without checking their contents into git";
    license = self.stdenv.lib.licenses.gpl3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.simons ];
  };
})
