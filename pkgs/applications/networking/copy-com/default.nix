{ stdenv, fetchurl, patchelf, fontconfig, freetype
, gcc, glib, libICE, libSM, libX11, libXext, libXrender }:

let
  arch = if stdenv.system == "x86_64-linux" then "x86_64"
    else if stdenv.system == "i686-linux" then "x86"
    else if stdenv.system == "armv6-linux" then "armv6h"
    else throw "Copy.com client for: ${stdenv.system} not supported!";

  interpreter = if stdenv.system == "x86_64-linux" then "ld-linux-x86-64.so.2"
    else if stdenv.system == "i686-linux" then "ld-linux.so.2"
    else if stdenv.system == "armv6-linux" then "ld-linux.so.2"
    else throw "Copy.com client for: ${stdenv.system} not supported!";

  appdir = "opt/copy";
  
  libPackages = [ fontconfig freetype gcc.cc glib libICE libSM libX11 libXext
    libXrender ];
  libPaths = stdenv.lib.concatStringsSep ":"
    (map (path: "${path}/lib") libPackages);

in stdenv.mkDerivation {
  
  name = "copy-com-3.2.01.0481";

  src = fetchurl {
    # Note: copy.com doesn't version this file. Annoying.
    url = "https://copy.com/install/linux/Copy.tgz";
    sha256 = "0bpphm71mqpaiygs57kwa23nli0qm64fvgl1qh7fkxyqqabh4g7k";
  };

  nativeBuildInputs = [ patchelf ];

  phases = "unpackPhase installPhase";

  installPhase = ''
    mkdir -p $out/opt
    cp -r ${arch} "$out/${appdir}"

    mkdir -p "$out/bin"
    for binary in Copy{Agent,Console,Cmd}; do
      binary="$out/${appdir}/$binary"
      ln -sv "$binary" "$out/bin"
      patchelf --set-interpreter ${stdenv.glibc}/lib/${interpreter} "$binary"
    done

    # Older versions of this package happily installed broken copies of
    # anything other than CopyConsole - which was then also mangled to
    # copy_console for some reason. Keep backwards compatibility (only
    # for CopyConsole) for now; the NixOS service is already fixed.
    ln -sv "$out/bin"/{CopyConsole,copy_console}

    RPATH=${libPaths}:$out/${appdir}
    echo "Updating rpaths to $RPATH in:"
    find "$out/${appdir}" -type f -a -perm /0100 \
      -print -exec patchelf --force-rpath --set-rpath "$RPATH" {} \;
  '';

  meta = {
    homepage = http://copy.com;
    description = "Copy.com graphical & command-line clients";
    # Closed Source unfortunately.
    license = stdenv.lib.licenses.unfree;
    maintainers = with stdenv.lib.maintainers; [ nathan-gs nckx ];
    # NOTE: Copy.com itself only works on linux, so this is ok.
    platforms = stdenv.lib.platforms.linux;
  };
}
