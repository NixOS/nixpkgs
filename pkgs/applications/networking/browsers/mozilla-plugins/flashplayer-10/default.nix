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
, debug ? false

/* you have to add ~/mm.cfg :

    TraceOutputFileEnable=1
    ErrorReportingEnable=1
    MaxWarnings=1

  in order to read the flash trace at ~/.macromedia/Flash_Player/Logs/flashlog.txt
  Then FlashBug (a FireFox plugin) shows the log as well
*/

}:

stdenv.mkDerivation ({
  name = "flashplayer-10.0.32.18";

  builder = ./builder.sh;
  
  src =
    if stdenv.system == "x86_64-linux" then
      fetchurl (
        if debug then
          # no plans to provide a x86_64 version:
          # http://labs.adobe.com/technologies/flashplayer10/faq.html
          throw "no x86_64 debugging version available"
        else {
          # -> http://labs.adobe.com/downloads/flashplayer10_64bit.html
          url = http://download.macromedia.com/pub/labs/flashplayer10/libflashplayer-10.0.32.18.linux-x86_64.so.tar.gz;
          sha256 = "006k3jvahlq2v34q5mf2y7ghczhy6spsdd69fj120i9yz9zklhpw";
        }
      )
    else
      fetchurl ( if debug then {
        # The debug version also contains a player
        url = http://download.macromedia.com/pub/flashplayer/updaters/10/flash_player_10_linux_dev.tar.gz;
        sha256 = "0j3i4sbry9xdln23892hbkfbznqg2wzrakpfv4g5g6y7r2nchkfj";
      } else {
        url = http://fpdownload.macromedia.com/get/flashplayer/current/install_flash_player_10_linux.tar.gz;
        sha256 = "04ppx812dz4d93pkyx412z3jslkw8nsqw5gni467ipahqz6lifhi";
      });

  inherit zlib alsaLib;

  passthru = {
    mozillaPlugin = "/lib/mozilla/plugins";
  };

  rpath = stdenv.lib.makeLibraryPath [zlib alsaLib curl nss nspr fontconfig freetype expat libX11 libXext libXrender libXt gtk glib pango atk] ;

  meta = {
    description = "Adobe Flash Player browser plugin";
    homepage = http://www.adobe.com/products/flashplayer/;
  };
} // (if debug then {
    buildPhase = ''
      pwd;ls -l .
      tar xfz plugin/debugger/libflashplayer.so.tar.gz
    '';
  } else {} ) )
