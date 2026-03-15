{
  stdenv,
  lib,
  writeText,
  fetchurl,
  pkgsi686Linux,
  mpg123,
  runtimeShell,
}:

let
  libPath = lib.makeLibraryPath [
    pkgsi686Linux.stdenv.cc.cc
    pkgsi686Linux.libGL
    pkgsi686Linux.libGLU
    pkgsi686Linux.glib
    pkgsi686Linux.gtk2
    pkgsi686Linux.alsa-lib
    pkgsi686Linux.libsm
    pkgsi686Linux.libx11
    pkgsi686Linux.gdk-pixbuf
    pkgsi686Linux.pango
    pkgsi686Linux.libxinerama
  ];

in
stdenv.mkDerivation {
  pname = "kega-fusion";
  version = "3.63x";

  src = fetchurl {
    url = "http://www.carpeludum.com/download/Fusion363x.tar.gz";
    sha256 = "14s6czy20h5khyy7q95hd7k77v17ssafv9l6lafkiysvj2nmw94g";
  };

  plugins = fetchurl {
    url = "http://www.carpeludum.com/download/PluginsLinux.tar.gz";
    sha256 = "0d623cvh6n5ijj3wb64g93mxx2xbichsn7hj7brbb0ndw5cs70qj";
  };

  runner = writeText "kega-fusion" ''
    #!${runtimeShell} -ex

    kega_libdir="@out@/lib/kega-fusion"
    kega_localdir="$HOME/.Kega Fusion"

    # Force 32-bit gdk-pixbuf loaders
    export GDK_PIXBUF_MODULEDIR="${pkgsi686Linux.gdk-pixbuf}/lib/gdk-pixbuf-2.0/2.10.0/loaders"
    export GDK_PIXBUF_MODULE_FILE="${pkgsi686Linux.gdk-pixbuf}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache"

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

    # here we go!
    exec "$kega_libdir/Fusion" "$@"
  '';

  dontStrip = true;
  dontPatchELF = true;

  nativeBuildInputs = [
    pkgsi686Linux.upx
  ];

  buildInputs = [
    pkgsi686Linux.stdenv.cc.cc
    pkgsi686Linux.libGL
    pkgsi686Linux.libGLU
    pkgsi686Linux.glib
    pkgsi686Linux.gtk2
    pkgsi686Linux.alsa-lib
    pkgsi686Linux.libsm
    pkgsi686Linux.libx11
    pkgsi686Linux.gdk-pixbuf
    pkgsi686Linux.pango
    pkgsi686Linux.libxinerama
  ];

  installPhase = ''
    upx -d Fusion
    install -Dm755 Fusion "$out/lib/kega-fusion/Fusion"
    patchelf --set-interpreter "${pkgsi686Linux.stdenv.cc.bintools.dynamicLinker}" --set-rpath "${libPath}" "$out/lib/kega-fusion/Fusion"

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
    maintainers = [ ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfreeRedistributable;
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
    mainProgram = "kega-fusion";
  };
}
