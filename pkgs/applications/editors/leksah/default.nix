{ cabal, binary, binaryShared, Cabal, deepseq, filepath, glib, gtk
, gtksourceview2, hslogger, leksahServer, ltk, mtl, network, parsec
, processLeksah, regexBase, regexTdfa, strict, time, utf8String
}:

cabal.mkDerivation (self: {
  pname = "leksah";
  version = "0.10.0.4";
  sha256 = "1g12w1kl63fxzz1c2x237yrqkaja9awiqyyipkdms5iql0ini7bw";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    binary binaryShared Cabal deepseq filepath glib gtk gtksourceview2
    hslogger leksahServer ltk mtl network parsec processLeksah
    regexBase regexTdfa strict time utf8String
  ];
  noHaddock = true;
  meta = {
    homepage = "http://www.leksah.org";
    description = "Haskell IDE written in Haskell";
    license = "GPL";
    platforms = self.stdenv.lib.platforms.linux;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
