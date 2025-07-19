{
  stdenv,
  lib,
  writeText,
  fetchurl,
  mpg123,
  runtimeShell,
  pkgsi686Linux,
}:

let
  libPath = lib.makeLibraryPath [
    pkgsi686Linux.stdenv.cc.cc
    pkgsi686Linux.libGL
    pkgsi686Linux.libGLU
    pkgsi686Linux.glib
    pkgsi686Linux.gtk2
    pkgsi686Linux.alsa-lib
    pkgsi686Linux.xorg.libSM
    pkgsi686Linux.xorg.libX11
    pkgsi686Linux.gdk-pixbuf
    pkgsi686Linux.pango
    pkgsi686Linux.xorg.libXinerama
  ];

in
pkgsi686Linux.stdenv.mkDerivation {
  pname = "kega-fusion";
  version = "3.63x";

  src = fetchurl {
    url = "http://www.carpeludum.com/download/Fusion363x.tar.gz";
    hash = "sha256-jyRerZBb+zidooam7ZTWJ+xz5mmwJHy8h7NAIPxnRpM=";
  };

  plugins = fetchurl {
    url = "http://www.carpeludum.com/download/PluginsLinux.tar.gz";
    hash = "sha256-EoOjWeHNgrXyOhIeqyGLq4ve60iPmMWHlLFYAzcbwjQ=";
  };

  runner = writeText "kega-fusion" ''
    #!${runtimeShell} -ex

    kega_libdir="@out@/lib/kega-fusion"
    kega_localdir="$HOME/.Kega Fusion"

    # create local plugins directory if not present
    mkdir -p "$kega_localdir/Plugins"

    # create links for every included plugin
    if [ $(ls -1A $kega_libdir/plugins | wc -l) -gt 0 ]; then
      for i in $kega_libdir/plugins/*; do
        if [ ! -e "$kega_localdir/Plugins/$(basename "$i")" ]; then
          ln -sf "$i" "$kega_localdir/Plugins/"
        fi
      done
    fi

    # copy configuration file if not present
    if ! [ -f "$kega_localdir/Fusion.ini" ]; then
      cat > "$kega_localdir/Fusion.ini" <<EOF
    ALSADeviceName=default
    libmpg123path=${lib.getLib mpg123}/lib/libmpg123.so.0
    EOF
    else
      sed -i 's,^\(libmpg123path=\).*,\1${lib.getLib mpg123}/lib/libmpg123.so.0,' "$kega_localdir/Fusion.ini"
    fi
    # Set GDK_PIXBUF_MODULE_FILE to use 32-bit loaders
    export GDK_PIXBUF_MODULE_FILE="${pkgsi686Linux.gdk-pixbuf}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache"
    # here we go!
    exec "$kega_libdir/Fusion" "$@"
  '';

  dontStrip = true;
  dontPatchELF = true;

  nativeBuildInputs = [ pkgsi686Linux.upx ];

  installPhase = ''
    upx -d Fusion
    install -Dm755 Fusion "$out/lib/kega-fusion/Fusion"
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" --set-rpath "${libPath}" "$out/lib/kega-fusion/Fusion"

    tar -xaf $plugins
    mkdir -p "$out/lib/kega-fusion/plugins"
    cp -r Plugins/*.rpi "$out/lib/kega-fusion/plugins"

    mkdir -p "$out/bin"
    substitute "$runner" "$out/bin/kega-fusion" --subst-var out
    chmod +x "$out/bin/kega-fusion"
  '';

  meta = {
    description = "Sega SG1000, SC3000, SF7000, Master System, Game Gear, Genesis/Megadrive, SVP, Pico, SegaCD/MegaCD and 32X emulator";
    homepage = "https://www.carpeludum.com/kega-fusion/";
    maintainers = with lib.maintainers; [ abbradar ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfreeRedistributable;
    platforms = [ "i686-linux" ];
    mainProgram = "kega-fusion";
  };
}
