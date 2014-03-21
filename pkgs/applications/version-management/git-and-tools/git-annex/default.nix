{ cabal, aeson, async, blazeBuilder, bloomfilter, bup, byteable
, caseInsensitive, clientsession, cryptoApi, cryptohash, curl
, dataDefault, dataenc, DAV, dbus, dlist, dns, editDistance
, extensibleExceptions, feed, filepath, git, gnupg1, gnutls, hamlet
, hinotify, hS3, hslogger, HTTP, httpClient, httpConduit, httpTypes
, IfElse, json, liftedBase, lsof, MissingH
, MonadCatchIOTransformers, monadControl, mtl, network
, networkConduit, networkInfo, networkMulticast
, networkProtocolXmpp, openssh, optparseApplicative, perl
, QuickCheck, random, regexTdfa, rsync, SafeSemaphore, securemem
, SHA, stm, tasty, tastyHunit, tastyQuickcheck, tastyRerun, text
, time, transformers, unixCompat, utf8String, uuid, wai, waiLogger
, warp, warpTls, which, xmlTypes, yesod, yesodCore, yesodDefault
, yesodForm, yesodStatic
}:

cabal.mkDerivation (self: {
  pname = "git-annex";
  version = "5.20140320";
  sha256 = "0jhg5nbvdsiaprpj4h57fpfskhx0nqva4yx6krfd90i9gwgkm8l5";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    aeson async blazeBuilder bloomfilter byteable caseInsensitive
    clientsession cryptoApi cryptohash dataDefault dataenc DAV dbus
    dlist dns editDistance extensibleExceptions feed filepath gnutls
    hamlet hinotify hS3 hslogger HTTP httpClient httpConduit httpTypes
    IfElse json liftedBase MissingH MonadCatchIOTransformers
    monadControl mtl network networkConduit networkInfo
    networkMulticast networkProtocolXmpp optparseApplicative QuickCheck
    random regexTdfa SafeSemaphore securemem SHA stm tasty tastyHunit
    tastyQuickcheck tastyRerun text time transformers unixCompat
    utf8String uuid wai waiLogger warp warpTls xmlTypes yesod yesodCore
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
