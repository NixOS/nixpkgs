{stdenv, fetchurl, x11, xineLib, libpng}:

stdenv.mkDerivation {
  name = "xine-ui-0.99.3";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/xine-ui-0.99.3.tar.gz;
    md5 = "aa7805a93e511e3d67dc1bf09a71fcdd";
  };
  buildInputs = [x11 xineLib libpng];
  configureFlags = "--without-readline";
}
