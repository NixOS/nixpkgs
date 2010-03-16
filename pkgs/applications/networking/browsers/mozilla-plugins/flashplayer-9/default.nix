{ stdenv
, fetchurl
, zlib
, alsaLib
, nss
, nspr
, fontconfig
, freetype
, expat
, libX11
, libXext
, libXrender
, libXt
, gtk
, glib
, pango
, atk

, customSrc ? null
}:

assert stdenv.system == "i686-linux";

stdenv.mkDerivation {
  name = "flashplayer-9.0.124.0";

  builder = ./builder.sh;
  src = if customSrc == null then
    fetchurl {
      url = http://download.macromedia.com/pub/flashplayer/installers/current/9/install_flash_player_9.tar.gz;
      sha256 = "1cnsjgmy7rwj3spzb5mmpmvzxjp435jisl0dd8s4rf4xskyy6d6r";
    }
  else customSrc;

  inherit zlib alsaLib;

  passthru = {
    mozillaPlugin = "/lib/mozilla/plugins";
  };

  rpath = stdenv.lib.makeLibraryPath [zlib alsaLib nss nspr fontconfig freetype expat libX11 libXext libXrender libXt gtk glib pango atk] ;

  meta = {
    description = "Adobe Flash Player browser plugin";
    homepage = http://www.adobe.com/products/flashplayer/;
  };
}
