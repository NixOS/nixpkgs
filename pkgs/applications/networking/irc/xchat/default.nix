{stdenv, fetchurl, glib, pkgconfig, tcl, gtk}:

stdenv.mkDerivation {
  name = "xchat-2.6.0";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/xchat-2.6.0.tar.bz2;
    md5 = "0c827bf6df0572231cbbb1e25965fb61";
  };
  buildInputs = [glib pkgconfig tcl gtk];
  configureFlags = "--disable-nls";
}
