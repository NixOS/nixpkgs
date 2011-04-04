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
, cairo
, atk
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

  src =
    if stdenv.system == "x86_64-linux" then
      if debug then
        # no plans to provide a x86_64 version:
        # http://labs.adobe.com/technologies/flashplayer10/faq.html
        throw "no x86_64 debugging version available"
      else {
        # -> http://labs.adobe.com/downloads/flashplayer10.html
        version = "10.1_p2-r092710";
        url = http://download.macromedia.com/pub/labs/flashplayer10/flashplayer_square_p2_64bit_linux_092710.tar.gz;
        sha256 = "188dn08n3rb6w3hzq4snqvip5njxdyc8k8arp8xnlqw331lfvapx";
      }
    else if stdenv.system == "i686-linux" then
      if debug then {
        # The debug version also contains a player
        version = "10.2_p2-debug-r092710";
        url = http://download.macromedia.com/pub/labs/flashplayer10/flashplayer_square_p2_32bit_debug_linux_092710.tar.gz;
        sha256 = "11w3mxa39l4mnlsqzlwbdh1sald549afyqbx2kbid7in5qzamlcc";
      } else {
        version = "10.2.153.1";
        url = http://fpdownload.macromedia.com/get/flashplayer/current/install_flash_player_10_linux.tar.gz;
        sha256 = "1ydax5bvxdz4r0c0l4knmnmixap2q2b78kfaa2zpz4i3y1n9z22p";
      }
    else throw "flashplayer is not supported on this platform";

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
    [ zlib alsaLib curl nss nspr fontconfig freetype expat libX11
      libXext libXrender libXt gtk glib pango atk cairo
    ];

  buildPhase = ":";

  meta = {
    description = "Adobe Flash Player browser plugin";
    homepage = http://www.adobe.com/products/flashplayer/;
  };
}
