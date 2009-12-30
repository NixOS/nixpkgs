{ stdenv
, fetchurl
, zlib
, alsaLib
, curl
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
}:

stdenv.mkDerivation {
  name = "flashplayer-10.0.32.18";

  builder = ./builder.sh;
  
  src =
    if stdenv.system == "x86_64-linux" then
      fetchurl {
        url = http://download.macromedia.com/pub/labs/flashplayer10/libflashplayer-10.0.32.18.linux-x86_64.so.tar.gz;
        sha256 = "006k3jvahlq2v34q5mf2y7ghczhy6spsdd69fj120i9yz9zklhpw";
      }
    else
      fetchurl {
        url = http://fpdownload.macromedia.com/get/flashplayer/current/install_flash_player_10_linux.tar.gz;
        sha256 = "04ppx812dz4d93pkyx412z3jslkw8nsqw5gni467ipahqz6lifhi";
      };

  inherit zlib alsaLib;

  passthru = {
    mozillaPlugin = "/lib/mozilla/plugins";
  };

  rpath = stdenv.lib.makeLibraryPath [zlib alsaLib curl nss nspr fontconfig freetype expat libX11 libXext libXrender libXt gtk glib pango atk] ;

  meta = {
    description = "Adobe Flash Player browser plugin";
    homepage = http://www.adobe.com/products/flashplayer/;
  };
}
