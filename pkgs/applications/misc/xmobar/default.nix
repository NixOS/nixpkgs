{cabal, X11}:

cabal.mkDerivation (self : {
  pname = "xmobar";
  name = "${self.fname}";
  version = "0.8";
  sha256 = "88aa5bc0715e2592282e5897bc7938f16580804f56757bc71ed3762bf86c9415";
  extraBuildInputs = [X11];
  meta = {
    description = "xmobar is a minimalistic text based status bar";
  };
})
