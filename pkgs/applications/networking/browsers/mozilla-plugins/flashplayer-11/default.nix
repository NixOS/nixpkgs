{ stdenv
, fetchurl
, zlib
, alsaLib
, curl
, nspr
, fontconfig
, freetype
, expat
, libX11
, libXext
, libXrender
, libXcursor
, libXt
, libvdpau
, gtk
, glib
, pango
, cairo
, atk
, gdk_pixbuf
, nss
, debug ? false

/* you have to add ~/mm.cfg :

    TraceOutputFileEnable=1
    ErrorReportingEnable=1
    MaxWarnings=1

  in order to read the flash trace at ~/.macromedia/Flash_Player/Logs/flashlog.txt
  Then FlashBug (a FireFox plugin) shows the log as well
*/

}:

let
  # -> http://get.adobe.com/flashplayer/
  version = "11.2.202.468";

  src =
    if stdenv.system == "x86_64-linux" then
      if debug then
        # no plans to provide a x86_64 version:
        # http://labs.adobe.com/technologies/flashplayer10/faq.html
        throw "no x86_64 debugging version available"
      else rec {
        inherit version;
        url = "http://fpdownload.adobe.com/get/flashplayer/pdc/${version}/install_flash_player_11_linux.x86_64.tar.gz";
        sha256 = "1vybrw5cwhl4zz9z4fy1lnvs60zz382blas7kann7wj8r4pvx0zl";
      }
    else if stdenv.system == "i686-linux" then
      if debug then
        throw "flash debugging version is outdated and probably broken" /* {
        # The debug version also contains a player
        version = "11.1";
        url = http://fpdownload.adobe.com/pub/flashplayer/updaters/11/flashplayer_11_plugin_debug.i386.tar.gz;
        sha256 = "0jn7klq2cyqasj6nxfka2l8nsf7sn7hi6443nv6dd2sb3g7m6x92";
      }*/
      else rec {
        inherit version;
        url = "http://fpdownload.adobe.com/get/flashplayer/pdc/${version}/install_flash_player_11_linux.i386.tar.gz";
        sha256 = "1bczdgda040nnfmr9sq4q1a0dy9zbnq76g4dsjw3md4glxkmqv8l";
      }
    else throw "Flash Player is not supported on this platform";

in

stdenv.mkDerivation {
  name = "flashplayer-${src.version}";

  builder = ./builder.sh;

  src = fetchurl { inherit (src) url sha256; };

  inherit zlib alsaLib;

  passthru = {
    mozillaPlugin = "/lib/mozilla/plugins";
  };

  rpath = stdenv.lib.makeLibraryPath
    [ zlib alsaLib curl nspr fontconfig freetype expat libX11
      libXext libXrender libXcursor libXt gtk glib pango atk cairo gdk_pixbuf
      libvdpau nss
    ];

  buildPhase = ":";

  meta = {
    description = "Adobe Flash Player browser plugin";
    homepage = http://www.adobe.com/products/flashplayer/;
    license = stdenv.lib.licenses.unfree;
  };
}
