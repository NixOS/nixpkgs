{ stdenv
, lib
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

  suffix =
    if      stdenv.system == "x86_64-linux" then
      if    debug then throw "no x86_64 debugging version available"
      else             "-release.x86_64"
    else if stdenv.system == "i686-linux"   then
      if    debug then "_linux_debug.i386"
      else             "_linux.i386"
    else throw "Flash Player is not supported on this platform";

  is-i686 = (stdenv.system == "i686-linux");
in
stdenv.mkDerivation rec {
  name = "flashplayer-${version}";
  version = "11.2.202.577";

  src = fetchurl {
    url = "https://fpdownload.macromedia.com/pub/flashplayer/installers/archive/fp_${version}_archive.zip";
    sha256 = "1k02d6c9y8z9lxyqyq04zsc5735cvm30mkwli71mh87fr1va2q4j";
  };

  buildInputs = [ unzip ];

  postUnpack = ''
    pushd $sourceRoot
    tar -xvzf *${arch}/*${suffix}.tar.gz

    ${ lib.optionalString is-i686 ''
       tar -xvzf */*_sa.*.tar.gz
       tar -xvzf */*_sa_debug.*.tar.gz
    ''}

    popd
  '';

  sourceRoot = "fp_${version}_archive";

  dontStrip = true;
  dontPatchELF = true;

  outputs = [ "out" ] ++ lib.optionals is-i686 ["sa" "saDbg" ];

  installPhase = ''
    mkdir -p $out/lib/mozilla/plugins
    cp -pv libflashplayer.so $out/lib/mozilla/plugins
    patchelf --set-rpath "$rpath" $out/lib/mozilla/plugins/libflashplayer.so

    ${ lib.optionalString is-i686 ''
       mkdir -p $sa/bin
       cp flashplayer $sa/bin/

       patchelf \
         --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
         --set-rpath "$rpath" \
         $sa/bin/flashplayer


       mkdir -p $saDbg/bin
       cp flashplayerdebugger $saDbg/bin/

       patchelf \
         --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
         --set-rpath "$rpath" \
         $saDbg/bin/flashplayerdebugger
    ''}
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
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}
