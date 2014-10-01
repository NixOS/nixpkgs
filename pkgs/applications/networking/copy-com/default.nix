{ stdenv, coreutils, fetchurl, patchelf, gcc }:

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
  
in stdenv.mkDerivation {
  
  name = "copy-com-1.47.0410";

  src = fetchurl {
    # Note: copy.com doesn't version this file. Annoying.
    url = "https://copy.com/install/linux/Copy.tgz";
    sha256 = "a48c69f6798f888617cfeef5359829e619057ae0e6edf3940b4ea6c81131012a";
  };

  buildInputs = [ coreutils patchelf ];

  phases = "unpackPhase installPhase";

  installPhase = ''
    mkdir -p $out/opt
    cp -r ${arch} "$out/${appdir}"
    ensureDir "$out/bin"
    ln -s "$out/${appdir}/CopyConsole" "$out/bin/copy_console"
    ln -s "$out/${appdir}/CopyAgent" "$out/bin/copy_agent"
    ln -s "$out/${appdir}/CopyCmd" "$out/bin/copy_cmd"
    patchelf --set-interpreter ${stdenv.glibc}/lib/${interpreter} \
      "$out/${appdir}/CopyConsole"

    RPATH=${gcc.gcc}/lib:$out/${appdir}
    echo "updating rpaths to: $RPATH"
    find "$out/${appdir}" -type f -a -perm +0100 \
      -print -exec patchelf --force-rpath --set-rpath "$RPATH" {} \;



  '';

  meta = {
    homepage = http://copy.com;
    description = "Copy.com Client";
    # Closed Source unfortunately.
    license = stdenv.lib.licenses.unfree;
    maintainers = with stdenv.lib.maintainers; [ nathan-gs ];
    # NOTE: Copy.com itself only works on linux, so this is ok.
    platforms = stdenv.lib.platforms.linux;
  };
}
