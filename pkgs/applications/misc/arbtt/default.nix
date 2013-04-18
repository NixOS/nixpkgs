{ cabal, binary, bytestringProgress, deepseq, filepath, parsec
, pcreLight, strict, terminalProgressBar, time, transformers
, utf8String, X11, libXScrnSaver
}:

cabal.mkDerivation (self: {
  pname = "arbtt";
  version = "0.7";
  sha256 = "05q31fsyrbkcx0mlf2r91zgmpma5sl2a7100h7qsa882sijc2ybn";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    binary bytestringProgress deepseq filepath parsec pcreLight strict
    terminalProgressBar time transformers utf8String X11
  ];
  extraLibraries = [ libXScrnSaver ];
  meta = {
    homepage = "http://www.joachim-breitner.de/projects#arbtt";
    description = "Automatic Rule-Based Time Tracker";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
  };
})
