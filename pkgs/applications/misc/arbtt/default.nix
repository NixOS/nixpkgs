{ cabal, aeson, binary, bytestringProgress, deepseq, filepath
, HUnit, libXScrnSaver, parsec, pcreLight, processExtras, strict
, tasty, tastyGolden, tastyHunit, terminalProgressBar, time
, transformers, utf8String, X11
}:

cabal.mkDerivation (self: {
  pname = "arbtt";
  version = "0.8.1";
  sha256 = "1qzmqjm8pfj59h0hrm28pp6qhzz2am5xq81mirnnchsgg52wrfn0";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    aeson binary bytestringProgress deepseq filepath parsec pcreLight
    strict terminalProgressBar time transformers utf8String X11
  ];
  testDepends = [
    binary deepseq HUnit parsec pcreLight processExtras tasty
    tastyGolden tastyHunit time transformers utf8String
  ];
  extraLibraries = [ libXScrnSaver ];
  jailbreak = true;
  meta = {
    homepage = "http://arbtt.nomeata.de/";
    description = "Automatic Rule-Based Time Tracker";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
  };
})
