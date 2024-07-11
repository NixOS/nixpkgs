{ lib
, patchelf
, requireFile
, stdenv
# arguments from default.nix
, lang
, meta
, name
, src
, version
# dependencies
, alsa-lib
, coreutils
, cudaPackages
, dbus
, fontconfig
, freetype
, gcc
, glib
, libGL
, libGLU
, libuuid
, libxml2
, ncurses
, opencv2
, openssl
, unixODBC
, xkeyboard_config
, xorg
, zlib
# options
, cudaSupport
}:

stdenv.mkDerivation rec {
  inherit meta name src version;

  buildInputs = [
    coreutils
    patchelf
    alsa-lib
    coreutils
    dbus
    fontconfig
    freetype
    gcc.cc
    gcc.libc
    glib
    ncurses
    opencv2
    openssl
    unixODBC
    xkeyboard_config
    libxml2
    libuuid
    zlib
    libGL
    libGLU
  ] ++ (with xorg; [
    libX11
    libXext
    libXtst
    libXi
    libXmu
    libXrender
    libxcb
    libXcursor
    libXfixes
    libXrandr
    libICE
    libSM
  ]);

  ldpath = lib.makeLibraryPath buildInputs
    + lib.optionalString (stdenv.hostPlatform.system == "x86_64-linux")
      (":" + lib.makeSearchPathOutput "lib" "lib64" buildInputs);

  dontConfigure = true;
  dontBuild = true;

  unpackPhase = ''
    echo "=== Extracting makeself archive ==="
    # find offset from file
    offset=$(${stdenv.shell} -c "$(grep -axm1 -e 'offset=.*' $src); echo \$offset" $src)
    dd if="$src" ibs=$offset skip=1 | tar -xf -
    cd Unix
  '';

  installPhase = ''
    cd Installer
    # don't restrict PATH, that has already been done
    sed -i -e 's/^PATH=/# PATH=/' MathInstaller
    sed -i -e 's/\/bin\/bash/\/bin\/sh/' MathInstaller

    echo "=== Running MathInstaller ==="
    ./MathInstaller -auto -createdir=y -execdir=$out/bin -targetdir=$out/libexec/Mathematica -silent

    # Fix library paths
    cd $out/libexec/Mathematica/Executables
    for path in mathematica MathKernel Mathematica WolframKernel wolfram math; do
      sed -i -e 's#export LD_LIBRARY_PATH$#export LD_LIBRARY_PATH=${zlib}/lib:\''${LD_LIBRARY_PATH}#' $path
    done

    # Fix xkeyboard config path for Qt
    for path in mathematica Mathematica; do
      line=$(grep -n QT_PLUGIN_PATH $path | sed 's/:.*//')
      sed -i -e "$line iexport QT_XKB_CONFIG_ROOT=\"${xkeyboard_config}/share/X11/xkb\"" $path
    done
  '';

  preFixup = ''
    echo "=== PatchElfing away ==="
    # This code should be a bit forgiving of errors, unfortunately
    set +e
    find $out/libexec/Mathematica/SystemFiles -type f -perm -0100 | while read f; do
      type=$(readelf -h "$f" 2>/dev/null | grep 'Type:' | sed -e 's/ *Type: *\([A-Z]*\) (.*/\1/')
      if [ -z "$type" ]; then
        :
      elif [ "$type" == "EXEC" ]; then
        echo "patching $f executable <<"
        patchelf --shrink-rpath "$f"
        patchelf \
    --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
          --set-rpath "$(patchelf --print-rpath "$f"):${ldpath}" \
          "$f" \
          && patchelf --shrink-rpath "$f" \
          || echo unable to patch ... ignoring 1>&2
      elif [ "$type" == "DYN" ]; then
        echo "patching $f library <<"
        patchelf \
          --set-rpath "$(patchelf --print-rpath "$f"):${ldpath}" \
          "$f" \
          && patchelf --shrink-rpath "$f" \
          || echo unable to patch ... ignoring 1>&2
      else
        echo "not patching $f <<: unknown elf type"
      fi
    done
  '';

  # all binaries are already stripped
  dontStrip = true;

  # we did this in prefixup already
  dontPatchELF = true;
}
