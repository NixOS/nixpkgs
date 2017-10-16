{ stdenv
, lib
, fetchurl
, alsaLib
, atk
, bzip2
, cairo
, curl
, expat
, fontconfig
, freetype
, gdk_pixbuf
, glib
, glibc
, graphite2
, gtk2
, harfbuzz
, libICE
, libSM
, libX11
, libXau
, libXcomposite
, libXcursor
, libXdamage
, libXdmcp
, libXext
, libXfixes
, libXi
, libXinerama
, libXrandr
, libXrender
, libXt
, libXxf86vm
, libdrm
, libffi
, libpng
, libvdpau
, libxcb
, libxshmfence
, nspr
, nss
, pango
, pcre
, pixman
, zlib
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
    if stdenv.system == "x86_64-linux" then
      "x86_64"
    else if stdenv.system == "i686-linux"   then
      "i386"
    else throw "Flash Player is not supported on this platform";
  lib_suffix =
      if stdenv.system == "x86_64-linux" then
      "64"
    else
      "";
in
stdenv.mkDerivation rec {
  name = "flashplayer-${version}";
  version = "27.0.0.170";

  src = fetchurl {
    url =
      if debug then
        "https://fpdownload.macromedia.com/pub/flashplayer/updaters/27/flash_player_npapi_linux_debug.${arch}.tar.gz"
      else
        "https://fpdownload.adobe.com/get/flashplayer/pdc/${version}/flash_player_npapi_linux.${arch}.tar.gz";
    sha256 =
      if debug then
        if arch == "x86_64" then
          "018dx7vpl8ha5c7wlcvh422ll5f0zb9cb77cmylbai84dwb9wrvg"
        else
          "09qd15khv914xcr9c4vy770mm33bl6szfy334ddb5gv6dh6h2gd8"
      else
        if arch == "x86_64" then
          "0hyc25ygxrp8k0w1xmg5wx1d2l959glc23bjswf30agwlpyn2rwn"
        else
          "1jsq8lgs4jvplwkkb2pngnr7vq9xv9knajk2247qpraq51fq2vd0";
  };

  nativeBuildInputs = [ unzip ];

  sourceRoot = ".";

  dontStrip = true;
  dontPatchELF = true;

  preferLocalBuild = true;

  installPhase = ''
    mkdir -p $out/lib/mozilla/plugins
    cp -pv libflashplayer.so $out/lib/mozilla/plugins

    mkdir -p $out/bin
    cp -pv usr/bin/flash-player-properties $out/bin

    mkdir -p $out/lib${lib_suffix}/kde4
    cp -pv usr/lib${lib_suffix}/kde4/kcm_adobe_flash_player.so $out/lib${lib_suffix}/kde4

    patchelf --set-rpath "$rpath" \
      $out/lib/mozilla/plugins/libflashplayer.so \
      $out/lib${lib_suffix}/kde4/kcm_adobe_flash_player.so

    patchelf \
      --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
      --set-rpath "$rpath" \
      $out/bin/flash-player-properties
  '';

  passthru = {
    mozillaPlugin = "/lib/mozilla/plugins";
  };

  rpath = lib.makeLibraryPath
    [ stdenv.cc.cc
      alsaLib atk bzip2 cairo curl expat fontconfig freetype gdk_pixbuf glib
      glibc graphite2 gtk2 harfbuzz libICE libSM libX11 libXau libXcomposite
      libXcursor libXdamage libXdmcp libXext libXfixes libXi libXinerama
      libXrandr libXrender libXt libXxf86vm libdrm libffi libpng libvdpau
      libxcb libxshmfence nspr nss pango pcre pixman zlib
    ];

  meta = {
    description = "Adobe Flash Player browser plugin";
    homepage = http://www.adobe.com/products/flashplayer/;
    license = stdenv.lib.licenses.unfree;
    maintainers = [];
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}
