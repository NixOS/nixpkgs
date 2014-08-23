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
  version = "11.2.202.394";

  src =
    if stdenv.system == "x86_64-linux" then
      if debug then
        # no plans to provide a x86_64 version:
        # http://labs.adobe.com/technologies/flashplayer10/faq.html
        throw "no x86_64 debugging version available"
      else rec {
        inherit version;
        url = "http://fpdownload.macromedia.com/get/flashplayer/pdc/${version}/install_flash_player_11_linux.x86_64.tar.gz";
        sha256 = "1w82kmda91xdsrqpkrbcbrzswnbfszy0x9hvf9wf2h14isimdknx";
      }
    else if stdenv.system == "i686-linux" then
      if debug then {
        # The debug version also contains a player
        version = "11.1";
        url = http://fpdownload.macromedia.com/pub/flashplayer/updaters/11/flashplayer_11_plugin_debug.i386.tar.gz;
        sha256 = "1z3649lv9sh7jnwl8d90a293nkaswagj2ynhsr4xmwiy7c0jz2lk";
      } else rec {
        inherit version;
        url = "http://fpdownload.macromedia.com/get/flashplayer/pdc/${version}/install_flash_player_11_linux.i386.tar.gz";
        sha256 = "0c8wp4qn6k224krihxb08g7727wlklk9bl4h7nqp3cpp85x9hg97";
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
    maintainers = with stdenv.lib.maintainers; [ wizeman ];
    license = stdenv.lib.licenses.unfree;
  };
}
