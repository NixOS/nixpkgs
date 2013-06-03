{ cabal, aeson, async, blazeBuilder, bloomfilter, bup
, caseInsensitive, clientsession, cryptoApi, curl, dataDefault
, dataenc, DAV, dbus, dlist, dns, editDistance
, extensibleExceptions, filepath, git, gnupg1, gnutls, hamlet
, hinotify, hS3, hslogger, HTTP, httpConduit, httpTypes, HUnit
, IfElse, json, lsof, MissingH, MonadCatchIOTransformers
, monadControl, mtl, network, networkInfo, networkMulticast
, networkProtocolXmpp, openssh, QuickCheck, random, regexTdfa
, rsync, SafeSemaphore, SHA, stm, text, time, transformers
, unixCompat, utf8String, uuid, wai, waiLogger, warp, xmlConduit
, xmlTypes, yesod, yesodDefault, yesodForm, yesodStatic
}:

cabal.mkDerivation (self: {
  pname = "git-annex";
  version = "4.20130601";
  sha256 = "0l6jbi9r26w5h9hfg9v9qybqvijp4n7c9l1zd4ikxg2nqcc8j8ln";
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
    uuid wai waiLogger warp xmlConduit xmlTypes yesod yesodDefault
    yesodForm yesodStatic
  ];
  buildTools = [ bup curl git gnupg1 lsof openssh rsync ];
  configureFlags = "-fS3
                    -fWebDAV
                    -fInotify
                    -fDbus
                    -f-Assistant
                    -f-Webapp
                    -fPairing
                    -fXMPP
                    -fDNS
                    -fProduction
                    -fTDFA";
  preConfigure = "patchShebangs .";
  checkPhase = ''
    export HOME="$NIX_BUILD_TOP/tmp"
    mkdir "$HOME"
    cp dist/build/git-annex/git-annex git-annex
    ./git-annex test
  '';
  meta = {
    homepage = "http://git-annex.branchable.com/";
    description = "manage files with git, without checking their contents into git";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.simons ];
  };
})
