{stdenv, fetchurl, pkgconfig, tcl, gtk}:

stdenv.mkDerivation {
  name = "xchat-2.8.8";
  src = fetchurl {
    url = http://www.xchat.org/files/source/2.8/xchat-2.8.8.tar.bz2;
    sha256 = "0d6d69437b5e1e45f3e66270fe369344943de8a1190e498fafa5296315a27db0";
  };
  buildInputs = [pkgconfig tcl gtk];
  configureFlags = "--disable-nls";

  patches = [ ./glib-top-level-header.patch ];

  meta = {
    description = "IRC client using GTK";
    homepage = http://www.xchat.org;
    platforms = with stdenv.lib.platforms; linux;
  };
}
