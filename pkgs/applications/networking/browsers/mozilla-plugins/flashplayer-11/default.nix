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
, unzip
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
  arch =
    if      stdenv.system == "x86_64-linux" then
      if    debug then throw "no x86_64 debugging version available"
      else  "64bit"
    else if stdenv.system == "i686-linux"   then
      if    debug then "32bit_debug"
      else             "32bit"
    else throw "Flash Player is not supported on this platform";
in
stdenv.mkDerivation rec {
  name = "flashplayer-${version}";
  version = "11.2.202.554";

  src = fetchurl {
    url = "https://fpdownload.macromedia.com/pub/flashplayer/installers/archive/fp_${version}_archive.zip";
    sha256 = "0pjan07k419pk3lmfdl5vww0ipf5b76cxqhxwjrikb1fc4x993fi";
  };

  buildInputs = [ unzip ];

  postUnpack = ''
    cd */*${arch}
    tar -xvzf flash-plugin*.tar.gz
  '';

  sourceRoot = ".";

  dontStrip = true;
  dontPatchELF = true;

  installPhase = ''
    mkdir -p $out/lib/mozilla/plugins
    cp -pv libflashplayer.so $out/lib/mozilla/plugins
    patchelf --set-rpath "$rpath" $out/lib/mozilla/plugins/libflashplayer.so
  '';

  passthru = {
    mozillaPlugin = "/lib/mozilla/plugins";
  };

  rpath = stdenv.lib.makeLibraryPath
    [ zlib alsaLib curl nspr fontconfig freetype expat libX11
      libXext libXrender libXcursor libXt gtk glib pango atk cairo gdk_pixbuf
      libvdpau nss
    ];

  meta = {
    description = "Adobe Flash Player browser plugin";
    homepage = http://www.adobe.com/products/flashplayer/;
    license = stdenv.lib.licenses.unfree;
    maintainers = [];
  };
}
