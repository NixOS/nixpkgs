{ cabal, alsaCore, alsaMixer, dbus, filepath, hinotify, HTTP
, libmpd, libXrandr, mtl, parsec, regexCompat, stm, time
, timezoneOlson, timezoneSeries, utf8String, wirelesstools, X11
, X11Xft
}:

cabal.mkDerivation (self: {
  pname = "xmobar";
  version = "0.20.1";
  sha256 = "16jfgn6ciqxrwj6qjhbcpms7mzlbxfaxyxfxp64xvnw626xlpjvk";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    alsaCore alsaMixer dbus filepath hinotify HTTP libmpd mtl parsec
    regexCompat stm time timezoneOlson timezoneSeries utf8String X11
    X11Xft
  ];
  extraLibraries = [ libXrandr wirelesstools ];
  configureFlags = "-fall_extensions";
  meta = {
    homepage = "http://projects.haskell.org/xmobar/";
    description = "A Minimalistic Text Based Status Bar";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
