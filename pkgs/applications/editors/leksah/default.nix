{ cabal, binary, binaryShared, Cabal, deepseq, enumerator, filepath
, gio, glib, gtk, gtksourceview2, hslogger, leksahServer, ltk, mtl
, network, parsec, QuickCheck, regexBase, regexTdfa, strict, text
, time, transformers, utf8String
}:

cabal.mkDerivation (self: {
  pname = "leksah";
  version = "0.12.0.3";
  sha256 = "1374ffwban58kabnynacl0fyzs6756kd5q1lcfya46mp26l7syrd";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    binary binaryShared Cabal deepseq enumerator filepath gio glib gtk
    gtksourceview2 hslogger leksahServer ltk mtl network parsec
    QuickCheck regexBase regexTdfa strict text time transformers
    utf8String
  ];
  noHaddock = true;
  meta = {
    homepage = "http://www.leksah.org";
    description = "Haskell IDE written in Haskell";
    license = "GPL";
    platforms = self.stdenv.lib.platforms.linux;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
