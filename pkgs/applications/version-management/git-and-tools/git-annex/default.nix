{ cabal, aeson, async, blazeBuilder, bloomfilter, bup
, caseInsensitive, clientsession, cryptoApi, curl, dataDefault
, dataenc, DAV, dbus, dlist, dns, editDistance
, extensibleExceptions, feed, filepath, git, gnupg1, gnutls, hamlet
, hinotify, hS3, hslogger, HTTP, httpConduit, httpTypes, HUnit
, IfElse, json, lsof, MissingH, MonadCatchIOTransformers
, monadControl, mtl, network, networkInfo, networkMulticast
, networkProtocolXmpp, openssh, QuickCheck, random, regexTdfa
, rsync, SafeSemaphore, SHA, stm, text, time, transformers
, unixCompat, utf8String, uuid, wai, waiLogger, warp, which
, xmlConduit, xmlTypes, yesod, yesodCore, yesodDefault, yesodForm
, yesodStatic, fetchurl, perl
}:

cabal.mkDerivation (self: {
  pname = "git-annex";
  version = "4.20130909";
  sha256 = "0rqbaz4hqfv1nxks62bx282vsvv7vzaxxz1576wk93f659rd06jp";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    aeson async blazeBuilder bloomfilter caseInsensitive clientsession
    cryptoApi dataDefault dataenc DAV dbus dlist dns editDistance
    extensibleExceptions feed filepath gnutls hamlet hinotify hS3
    hslogger HTTP httpConduit httpTypes HUnit IfElse json MissingH
    MonadCatchIOTransformers monadControl mtl network networkInfo
    networkMulticast networkProtocolXmpp QuickCheck random regexTdfa
    SafeSemaphore SHA stm text time transformers unixCompat utf8String
    uuid wai waiLogger warp xmlConduit xmlTypes yesod yesodCore
    yesodDefault yesodForm yesodStatic
  ];
  buildTools = [ bup curl git gnupg1 lsof openssh rsync which perl ];
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
  patches = [ (fetchurl { url = "https://github.com/joeyh/git-annex/commit/e4d0b2f180627472b017af8bcfc2ae3fc04d6767.patch";
                          sha256 = "08lz0zq5y3b3wgi1vbzka7kyihkhzjv02pmq8ab02674yrqrnr5k"; })
              (fetchurl { url = "https://github.com/joeyh/git-annex/commit/26baae8967d55d0793d0609475a75d265bdd64a3.patch";
                          sha256 = "0yzgj55jjcqv1975bnj4wafyh4vdzjjn4ajx3wahsyg0gsrm5lpv"; })
            ];
  meta = {
    homepage = "http://git-annex.branchable.com/";
    description = "manage files with git, without checking their contents into git";
    license = self.stdenv.lib.licenses.gpl3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.simons ];
  };
})
