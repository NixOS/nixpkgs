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
}:

assert stdenv.system == "i686-linux";

stdenv.mkDerivation {
  name = "flashplayer-9.0.124.0";

  builder = ./builder.sh;
  src = fetchurl {
    url = http://fpdownload.macromedia.com/get/flashplayer/current/install_flash_player_9_linux.tar.gz;
    sha256 = "16p98jf3y9041p8fk6cq7dqj7s4l4m7g9nhvc3dmhmld0075qagl";
  };

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
