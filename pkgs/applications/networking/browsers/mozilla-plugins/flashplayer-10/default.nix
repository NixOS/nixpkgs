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

let

  src =
    if stdenv.system == "x86_64-linux" then
      if debug then
        # no plans to provide a x86_64 version:
        # http://labs.adobe.com/technologies/flashplayer10/faq.html
        throw "no x86_64 debugging version available"
      else {
        # -> http://labs.adobe.com/downloads/flashplayer10_64bit.html
        version = "10.0.45.2";
        url = http://download.macromedia.com/pub/labs/flashplayer10/libflashplayer-10.0.45.2.linux-x86_64.so.tar.gz;
        sha256 = "1mkl02cplcl9dygmgzzwic0r7kkdgfkmpfzvk76l665pgf5bbazf";
      }
    else if stdenv.system == "i686-linux" then
      if debug then {
        # The debug version also contains a player
        version = "10.1pre2-debug-121709";
        url = http://download.macromedia.com/pub/labs/flashplayer10/flashplayer10_1_p2_debug_linux_121709.tar.gz;
        sha256 = "162cnzn8sfdvr8mwyggsxi2bcl7zzi1nrl61bw481hhhpwnrjdx4";
      } else {
        version = "10.1pre2-121709";
        url = http://download.macromedia.com/pub/labs/flashplayer10/flashplayer10_1_p2_linux_121709.tar.gz;
        sha256 = "1mzxcp7y5zxjnjdqmzq9dzg1jqs9lwb4j2njfhwiw2jifffjw2fw";
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
      libXext libXrender libXt gtk glib pango atk
    ];

  buildPhase = stdenv.lib.optionalString debug
    ''
      tar xfz plugin/debugger/libflashplayer.so.tar.gz
    '';

  meta = {
    description = "Adobe Flash Player browser plugin";
    homepage = http://www.adobe.com/products/flashplayer/;
  };
}
