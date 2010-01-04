{cabal, xmonad, X11, utf8String}:

cabal.mkDerivation (self : {
  pname = "xmonad-contrib";
  name = "${self.fname}";
  version = "0.9.1";
  sha256 = "b4ca1d71d12903be76187ce58898697086e7af3ef73468987cb7ef03b076ec47";
  propagatedBuildInputs = [X11 xmonad utf8String];
  meta = {
    description = "a huge extension library for xmonad";
  };
})
