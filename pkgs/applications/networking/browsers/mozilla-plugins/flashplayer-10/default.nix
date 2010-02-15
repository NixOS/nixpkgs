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
          url = http://download.macromedia.com/pub/labs/flashplayer10/libflashplayer-10.0.45.2.linux-x86_64.so.tar.gz;
          sha256 = "1mkl02cplcl9dygmgzzwic0r7kkdgfkmpfzvk76l665pgf5bbazf";
        }
      )
    else
      fetchurl ( if debug then {
        # The debug version also contains a player
        url = http://download.macromedia.com/pub/labs/flashplayer10/flashplayer10_1_p2_debug_linux_121709.tar.gz;
        sha256 = "162cnzn8sfdvr8mwyggsxi2bcl7zzi1nrl61bw481hhhpwnrjdx4";
      } else {
        url = http://download.macromedia.com/pub/labs/flashplayer10/flashplayer10_1_p2_linux_121709.tar.gz;
        sha256 = "1mzxcp7y5zxjnjdqmzq9dzg1jqs9lwb4j2njfhwiw2jifffjw2fw";
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
