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

/* When updating this package, test that the following derivations build:

   * flashplayer
   * flashplayer-standalone
   * flashplayer-standalone-debugger
*/

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
      else             "_linux.x86_64"
    else if stdenv.system == "i686-linux"   then
      if    debug then "_linux_debug.i386"
      else             "_linux.i386"
    else throw "Flash Player is not supported on this platform";

  saname =
    if debug then "flashplayerdebugger"
    else          "flashplayer";

  is-i686 = (stdenv.system == "i686-linux");
in
stdenv.mkDerivation rec {
  name = "flashplayer-${version}";
  version = "11.2.202.621";

  src = fetchurl {
    url = "https://fpdownload.macromedia.com/pub/flashplayer/installers/archive/fp_${version}_archive.zip";
    sha256 = "0xv7pzna4pfmi9bjwfbr0kf92xvdgpirm97kks4kphwngf3bzrm0";
  };

  nativeBuildInputs = [ unzip ];

  sourceRoot = ".";

  postUnpack = ''
    cd *${arch}

    tar -xvzf *${suffix}.tar.gz

    ${lib.optionalString is-i686 ''
       tar -xvzf *_sa[_.]*.tar.gz
    ''}
  '';

  dontStrip = true;
  dontPatchELF = true;

  outputs = [ "out" ] ++ lib.optional is-i686 "sa";

  installPhase = ''
    mkdir -p $out/lib/mozilla/plugins
    cp -pv libflashplayer.so $out/lib/mozilla/plugins

    patchelf --set-rpath "$rpath" $out/lib/mozilla/plugins/libflashplayer.so

    ${lib.optionalString is-i686 ''
      install -Dm755 ${saname} $sa/bin/flashplayer

      patchelf \
        --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
        --set-rpath "$rpath" \
        $sa/bin/flashplayer
    ''}
  '';

  passthru = {
    mozillaPlugin = "/lib/mozilla/plugins";
  };

  rpath = lib.makeLibraryPath
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
