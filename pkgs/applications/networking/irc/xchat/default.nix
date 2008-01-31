{stdenv, fetchurl, pkgconfig, tcl, gtk}:

stdenv.mkDerivation {
  name = "xchat-2.8.4";
  src = fetchurl {
    url = http://www.xchat.org/files/source/2.8/xchat-2.8.4.tar.bz2;
    sha256 = "0qyx6rdvnjwy52amcmkjj134sysfkzbyv7b66vjsla3i8yg9lnpr";
  };
  buildInputs = [pkgconfig tcl gtk];
  configureFlags = "--disable-nls";

  meta = {
    homepage = http://www.xchat.org;
  };
}
