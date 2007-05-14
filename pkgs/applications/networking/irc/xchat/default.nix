{stdenv, fetchurl, pkgconfig, tcl, gtk}:

stdenv.mkDerivation {
  name = "xchat-2.8.2";
  src = fetchurl {
    url = http://www.xchat.org/files/source/2.8/xchat-2.8.2.tar.bz2;
    sha256 = "1zjhjwr03nj52lpsvl78jwhir7q6482nnd4h1p0a9zka27kj4v4z";
  };
  buildInputs = [pkgconfig tcl gtk];
  configureFlags = "--disable-nls";
}
