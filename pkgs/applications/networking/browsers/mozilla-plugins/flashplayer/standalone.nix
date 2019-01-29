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
, libglvnd
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
}:

stdenv.mkDerivation rec {
  name = "flashplayer-standalone-${version}";
  version = "32.0.0.114";

  src = fetchurl {
    url =
      if debug then
        "https://fpdownload.macromedia.com/pub/flashplayer/updaters/32/flash_player_sa_linux_debug.x86_64.tar.gz"
      else
        "https://fpdownload.macromedia.com/pub/flashplayer/updaters/32/flash_player_sa_linux.x86_64.tar.gz";
    sha256 =
      if debug then
        "0wlzqdnl8lhbc428gcahld842bhia4aygy1k5vyyg27fwmskxhy7"
      else
        "01a1dwrgw7lc098vp4ifkf5bj2qvv0pmdyibjhzzrx3387d1pd2l";
  };

  nativeBuildInputs = [ unzip ];

  sourceRoot = ".";

  dontStrip = true;
  dontPatchELF = true;

  preferLocalBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    cp -pv flashplayer${lib.optionalString debug "debugger"} $out/bin

    patchelf \
      --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
      --set-rpath "$rpath" \
      $out/bin/flashplayer${lib.optionalString debug "debugger"}
  '';

  rpath = lib.makeLibraryPath
    [ stdenv.cc.cc
      alsaLib atk bzip2 cairo curl expat fontconfig freetype gdk_pixbuf glib
      glibc graphite2 gtk2 harfbuzz libICE libSM libX11 libXau libXcomposite
      libXcursor libXdamage libXdmcp libXext libXfixes libXi libXinerama
      libXrandr libXrender libXt libXxf86vm libdrm libffi libglvnd libpng
      libvdpau libxcb libxshmfence nspr nss pango pcre pixman zlib
    ];

  meta = {
    description = "Adobe Flash Player standalone executable";
    homepage = https://www.adobe.com/support/flashplayer/debug_downloads.html;
    license = stdenv.lib.licenses.unfree;
    maintainers = [];
    platforms = [ "x86_64-linux" ];
    # Application crashed with an unhandled SIGSEGV
    # Not on all systems, though. Video driver problem?
    broken = false;
  };
}
