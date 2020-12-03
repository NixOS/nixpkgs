{ stdenv
, coreutils
, patchelf
, requireFile
, callPackage
, alsaLib
, dbus
, fontconfig
, freetype
, gcc
, glib
, libssh2
, ncurses
, opencv2
, openssl
, unixODBC
, xkeyboard_config
, xorg
, zlib
, libxml2
, libuuid
, lang ? "en"
, libGL
, libGLU
}:

let
  l10n =
    import ./l10ns.nix {
      lib = stdenv.lib;
      inherit requireFile lang;
    };
in
stdenv.mkDerivation rec {
  inherit (l10n) version name src;

  buildInputs = [
    coreutils
    patchelf
    alsaLib
    coreutils
    dbus
    fontconfig
    freetype
    gcc.cc
    gcc.libc
    glib
    libssh2
    ncurses
    opencv2
    openssl
    stdenv.cc.cc.lib
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

  ldpath = stdenv.lib.makeLibraryPath buildInputs
    + stdenv.lib.optionalString (stdenv.hostPlatform.system == "x86_64-linux")
      (":" + stdenv.lib.makeSearchPathOutput "lib" "lib64" buildInputs);

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
      sed -i -e "2iexport LD_LIBRARY_PATH=${zlib}/lib:${stdenv.cc.cc.lib}/lib:${libssh2}/lib:\''${LD_LIBRARY_PATH}\n" $path
    done

    # Fix xkeyboard config path for Qt
    for path in mathematica Mathematica; do
      sed -i -e "2iexport QT_XKB_CONFIG_ROOT=\"${xkeyboard_config}/share/X11/xkb\"\n" $path
    done

    # Remove some broken libraries
    rm -f $out/libexec/Mathematica/SystemFiles/Libraries/Linux-x86-64/libz.so*
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

  dontBuild = true;
  
  # This is primarily an IO bound build; there's little benefit to building remotely.
  preferLocalBuild = true;

  # all binaries are already stripped
  dontStrip = true;

  # we did this in prefixup already
  dontPatchELF = true;

  meta = with stdenv.lib; {
    description = "Wolfram Mathematica computational software system";
    homepage = "http://www.wolfram.com/mathematica/";
    license = licenses.unfree;
    maintainers = with maintainers; [ herberteuler ];
    platforms = [ "x86_64-linux" ];
  };
}
