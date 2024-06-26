{
  lib,
  patchelf,
  requireFile,
  stdenv,
  # arguments from default.nix
  lang,
  meta,
  name,
  src,
  version,
  # dependencies
  alsa-lib,
  coreutils,
  cudaPackages,
  fontconfig,
  freetype,
  gcc,
  glib,
  libuuid,
  libxml2,
  ncurses,
  opencv2,
  openssl,
  unixODBC,
  xorg,
  # options
  cudaSupport,
}:

let
  platform =
    if stdenv.hostPlatform.system == "i686-linux" || stdenv.hostPlatform.system == "x86_64-linux" then
      "Linux"
    else
      throw "Mathematica requires i686-linux or x86_64 linux";
in
stdenv.mkDerivation rec {
  inherit meta src version;

  pname = "mathematica";

  buildInputs =
    [
      coreutils
      patchelf
      alsa-lib
      coreutils
      fontconfig
      freetype
      gcc.cc
      gcc.libc
      glib
      ncurses
      opencv2
      openssl
      unixODBC
      libxml2
      libuuid
    ]
    ++ (with xorg; [
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

  ldpath =
    lib.makeLibraryPath buildInputs
    + lib.optionalString (stdenv.hostPlatform.system == "x86_64-linux") (
      ":" + lib.makeSearchPathOutput "lib" "lib64" buildInputs
    );

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

    echo "=== Running MathInstaller ==="
    ./MathInstaller -auto -createdir=y -execdir=$out/bin -targetdir=$out/libexec/Mathematica -platforms=${platform} -silent
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
