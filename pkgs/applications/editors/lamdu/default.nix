{ cabal, aeson, binary, cryptohash, deepseq, derive, either
, fetchgit, filepath, GLFWB, graphicsDrawingcombinators, hashable
, lens, List, OpenGL, random, safe, sophia, split, StateVar, time
, TraceUtils, transformers, TypeCompose, utf8String
}:

cabal.mkDerivation (self: {
  pname = "lamdu";
  version = "0.1";
  src = fetchgit {
    url = "https://github.com/Peaker/lamdu";
    sha256 = "cee7587577a820fe8f1b02e9becf0c0465391d8f5ed260db0bbcb812fb9dfbfa";
    rev = "495f6339a587cd40f3b89630ac8a708a057eb3ae";
  };
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    aeson binary cryptohash deepseq derive either filepath GLFWB
    graphicsDrawingcombinators hashable lens List OpenGL random safe
    sophia split StateVar time TraceUtils transformers TypeCompose
    utf8String
  ];
  meta = {
    description = "A next generation IDE";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
  };
})
