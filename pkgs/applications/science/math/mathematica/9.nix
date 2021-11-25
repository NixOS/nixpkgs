{ lib
, stdenv
, coreutils
, patchelf
, requireFile
, alsa-lib
, fontconfig
, freetype
, gcc
, glib
, ncurses
, opencv2
, openssl
, unixODBC
, xorg
}:

let
  platform =
    if stdenv.hostPlatform.system == "i686-linux" || stdenv.hostPlatform.system == "x86_64-linux" then
      "Linux"
    else
      throw "Mathematica requires i686-linux or x86_64 linux";
in
stdenv.mkDerivation rec {
  pname = "mathematica";
  version = "9.0.0";

  src = requireFile {
    name = "Mathematica_${version}_LINUX.sh";
    message = ''
      This nix expression requires that Mathematica_9.0.0_LINUX.sh is
      already part of the store. Find the file on your Mathematica CD
      and add it to the nix store with nix-store --add-fixed sha256 <FILE>.
    '';
    sha256 = "106zfaplhwcfdl9rdgs25x83xra9zcny94gb22wncbfxvrsk3a4q";
  };

  buildInputs = [
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
  ] ++ (with xorg; [
    libX11
    libXext
    libXtst
    libXi
    libXmu
    libXrender
    libxcb
  ]);

  ldpath = lib.makeLibraryPath buildInputs
    + lib.optionalString (stdenv.hostPlatform.system == "x86_64-linux")
    (":" + lib.makeSearchPathOutput "lib" "lib64" buildInputs);

  phases = "unpackPhase installPhase fixupPhase";

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
    find $out/libexec/Mathematica/SystemFiles -type f -perm -0100 | while read f; do
      type=$(readelf -h "$f" 2>/dev/null | grep 'Type:' | sed -e 's/ *Type: *\([A-Z]*\) (.*/\1/')
      if [ -z "$type" ]; then
        :
      elif [ "$type" == "EXEC" ]; then
        echo "patching $f executable <<"
        patchelf \
            --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
            --set-rpath "${ldpath}" \
            "$f"
        patchelf --shrink-rpath "$f"
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

  meta = {
    description = "Wolfram Mathematica computational software system";
    homepage = "http://www.wolfram.com/mathematica/";
    license = lib.licenses.unfree;
  };
}
