{ cabal, attoparsec, gtk, hflags, lens, pipes, stm }:

cabal.mkDerivation (self: {
  pname = "nc-indicators";
  version = "0.1";
  sha256 = "19amwfcbwfxcj0gr7w0vgxl427l43q3l2s3n3zsxhqwkfblxmfy5";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [ attoparsec gtk hflags lens pipes stm ];
  meta = {
    homepage = "https://github.com/nilcons/nc-indicators/issues";
    description = "CPU load and memory usage indicators for i3bar";
    license = self.stdenv.lib.licenses.asl20;
    platforms = self.ghc.meta.platforms;
  };
})
