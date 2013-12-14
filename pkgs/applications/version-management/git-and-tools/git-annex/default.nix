{ cabal, aeson, async, blazeBuilder, bloomfilter, bup
, caseInsensitive, clientsession, cryptoApi, cryptohash, curl
, dataDefault, dataenc, DAV, dbus, dlist, dns, editDistance
, extensibleExceptions, feed, filepath, git, gnupg1, gnutls, hamlet
, hinotify, hS3, hslogger, HTTP, httpConduit, httpTypes, IfElse
, json, lsof, MissingH, MonadCatchIOTransformers, monadControl, mtl
, network, networkConduit, networkInfo, networkMulticast
, networkProtocolXmpp, openssh, perl, QuickCheck, random, regexTdfa
, rsync, SafeSemaphore, SHA, stm, tasty, tastyHunit
, tastyQuickcheck, text, time, transformers, unixCompat, utf8String
, uuid, wai, waiLogger, warp, which, xmlConduit, xmlTypes, yesod
, yesodCore, yesodDefault, yesodForm, yesodStatic
}:

cabal.mkDerivation (self: {
  pname = "git-annex";
  version = "5.20131213";
  sha256 = "0mwslkz0kklp4phlsf8hibh97sabdnigls7hr9725wb0ncfa85yn";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    aeson async blazeBuilder bloomfilter caseInsensitive clientsession
    cryptoApi cryptohash dataDefault dataenc DAV dbus dlist dns
    editDistance extensibleExceptions feed filepath gnutls hamlet
    hinotify hS3 hslogger HTTP httpConduit httpTypes IfElse json
    MissingH MonadCatchIOTransformers monadControl mtl network
    networkConduit networkInfo networkMulticast networkProtocolXmpp
    QuickCheck random regexTdfa SafeSemaphore SHA stm tasty tastyHunit
    tastyQuickcheck text time transformers unixCompat utf8String uuid
    wai waiLogger warp xmlConduit xmlTypes yesod yesodCore yesodDefault
    yesodForm yesodStatic
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
  preConfigure = "patchShebangs .";
  installPhase = "./Setup install";
  checkPhase = ''
    export HOME="$NIX_BUILD_TOP/tmp"
    mkdir "$HOME"
  '';
  meta = {
    homepage = "http://git-annex.branchable.com/";
    description = "manage files with git, without checking their contents into git";
    license = self.stdenv.lib.licenses.gpl3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.simons ];
  };
})
