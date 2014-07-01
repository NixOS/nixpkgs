{ cabal, attoparsec, gtk, hflags, lens, pipes, stm }:

cabal.mkDerivation (self: {
  pname = "nc-indicators";
  version = "0.2";
  sha256 = "0z3h0d3cl0xapysq5sh1rnbp8fg8adlq0x3i4ql9xin9in29q27q";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [ attoparsec gtk hflags lens pipes stm ];
  meta = {
    homepage = "https://github.com/nilcons/nc-indicators";
    description = "CPU load and memory usage indicators for i3bar";
    license = self.stdenv.lib.licenses.asl20;
    platforms = self.ghc.meta.platforms;
  };
})
