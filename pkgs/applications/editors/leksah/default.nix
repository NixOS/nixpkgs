{ cabal, binary, binaryShared, Cabal, deepseq, enumerator, filepath
, gio, glib, gtk, gtksourceview2, hslogger, leksahServer, ltk, mtl
, network, parsec, QuickCheck, regexBase, regexTdfa, strict, text
, time, transformers, utf8String
}:

cabal.mkDerivation (self: {
  pname = "leksah";
  version = "0.12.1.3";
  sha256 = "1w61wnd0nq9iqh0pwn9dz3m4qn3m0zasv0m3ki4k7plcdrmkqb3y";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    binary binaryShared Cabal deepseq enumerator filepath gio glib gtk
    gtksourceview2 hslogger leksahServer ltk mtl network parsec
    QuickCheck regexBase regexTdfa strict text time transformers
    utf8String
  ];
  testDepends = [ Cabal QuickCheck ];
  noHaddock = true;
  meta = {
    homepage = "http://www.leksah.org";
    description = "Haskell IDE written in Haskell";
    license = "GPL";
    platforms = self.stdenv.lib.platforms.linux;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
