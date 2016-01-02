{stdenv, fetchurl, pkgconfig, tcl, gtk, enchant }:

stdenv.mkDerivation {
  name = "xchat-2.8.8";
  src = fetchurl {
    url = http://www.xchat.org/files/source/2.8/xchat-2.8.8.tar.bz2;
    sha256 = "0d6d69437b5e1e45f3e66270fe369344943de8a1190e498fafa5296315a27db0";
  };
  buildInputs = [pkgconfig tcl gtk enchant ];
  configureFlags = "--disable-nls";

  patches = [ ./glib-top-level-header.patch ];


 #hexchat and heachat-text loads enchant spell checking library at run time and so it needs to have route to the path
  patchPhase = ''
    sed -i "s,libenchant.so.1,${enchant}/lib/libenchant.so.1,g" src/fe-gtk/sexy-spell-entry.c
  '';

  meta = {
    description = "IRC client using GTK";
    homepage = http://www.xchat.org;
    platforms = with stdenv.lib.platforms; linux;
  };
}
