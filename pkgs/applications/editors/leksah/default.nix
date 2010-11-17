{cabal, gtk, glib, binary, binaryShared, deepseq, hslogger, ltk, network, parsec,
 leksahServer, processLeksah, regexBase, regexTDFA, utf8String, gtksourceview2,
 makeWrapper}:

cabal.mkDerivation (self : {
  pname = "leksah";
  version = "0.8.0.8";
  sha256 = "1d6n5dlnqlqfckg9f611qf9lvi6b7ghrkk1l0myh6h667fxh8a1r";

  propagatedBuildInputs =
    [gtk glib binary binaryShared deepseq hslogger ltk network parsec
     leksahServer processLeksah regexBase regexTDFA utf8String gtksourceview2];
  extraBuildInputs = [makeWrapper];

  # postInstall =
  #   ''
  #     wrapProgram $out/bin/leksah --prefix XDG_DATA_DIRS : ${gtk2hs.gtksourceview}/share
  #   '';
  
  meta = {
    homepage = http://leksah.org/;
    description = "An Integrated Development Environment for Haskell written in Haskell";
    license = "GPL";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})  

