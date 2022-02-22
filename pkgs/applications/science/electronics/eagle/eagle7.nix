{ lib, stdenv, fetchurl, makeDesktopItem, patchelf, zlib, freetype, fontconfig
, openssl, libXrender, libXrandr, libXcursor, libX11, libXext, libXi
, libxcb, cups, xkeyboardconfig, runtimeShell
}:

let

  libPath = lib.makeLibraryPath
    [ zlib freetype fontconfig openssl libXrender libXrandr libXcursor libX11
      libXext libXi libxcb cups
    ];

in

stdenv.mkDerivation rec {
  pname = "eagle";
  version = "7.7.0";

  src =
    if stdenv.hostPlatform.system == "i686-linux" then
      fetchurl {
        url = "ftp://ftp.cadsoft.de/eagle/program/7.7/eagle-lin32-${version}.run";
        sha256 = "16fa66p77xigc7zvzfm7737mllrcs6nrgk2p7wvkjw3p9lvbz7z1";
      }
    else if stdenv.hostPlatform.system == "x86_64-linux" then
      fetchurl {
        url = "ftp://ftp.cadsoft.de/eagle/program/7.7/eagle-lin64-${version}.run";
        sha256 = "18dcn6wqph1sqh0ah98qzfi05wip8a8ifbkaq79iskbrsi8iqnrg";
      }
    else
      throw "Unsupported system: ${stdenv.hostPlatform.system}";

  desktopItem = makeDesktopItem {
    name = "eagle";
    exec = "eagle";
    icon = "eagle";
    comment = "Schematic capture and PCB layout";
    desktopName = "Eagle";
    genericName = "Schematic editor";
    categories = [ "Development" ];
  };

  buildInputs =
    [ patchelf zlib freetype fontconfig openssl libXrender libXrandr libXcursor
      libX11 libXext libXi
    ];

  dontUnpack = true;

  # NOTES:
  # Eagle for Linux comes as a self-extracting shell script with embedded
  # tarball. The tarball data (.tar.bz2) starts after a __DATA__ marker.
  #
  # Eagle apparently doesn't like binary patching. This is what happens:
  #   $ ./result/eagle-6.4.0/bin/eagle
  #   argv[0] (/home/bfo/nixpkgs/result/eagle-6.4.0/bin/eagle) is not the currently executed program version!
  installPhase = ''
    # Extract eagle tarball
    mkdir "$out"
    sed '1,/^__DATA__$/d' "$src" | tar -xjf - -C "$out"

    # Install manpage
    mkdir -p "$out"/share/man/man1
    ln -s "$out"/eagle-${version}/doc/eagle.1 "$out"/share/man/man1/eagle.1

    # Build LD_PRELOAD library that redirects license file access to the home
    # directory of the user
    mkdir -p "$out"/lib
    gcc -shared -fPIC -DEAGLE_PATH=\"$out/eagle-${version}\" ${./eagle7_fixer.c} -o "$out"/lib/eagle_fixer.so -ldl

    # Make wrapper script
    dynlinker="$(cat $NIX_CC/nix-support/dynamic-linker)"
    mkdir -p "$out"/bin
    cat > "$out"/bin/eagle << EOF
    #!${runtimeShell}
    export LD_LIBRARY_PATH="${stdenv.cc.cc.lib}/lib:${libPath}"
    export LD_PRELOAD="$out/lib/eagle_fixer.so"
    export QT_XKB_CONFIG_ROOT="${xkeyboardconfig}/share/X11/xkb"
    exec "$dynlinker" "$out/eagle-${version}/bin/eagle" "\$@"
    EOF
    chmod a+x "$out"/bin/eagle

    # Make desktop item
    mkdir -p "$out"/share/applications
    cp "$desktopItem"/share/applications/* "$out"/share/applications/
    mkdir -p "$out"/share/icons
    ln -s "$out/eagle-${version}/bin/eagleicon50.png" "$out"/share/icons/eagle.png
  '';

  meta = with lib; {
    description = "Schematic editor and PCB layout tool from CadSoft";
    homepage = "https://www.autodesk.com/products/eagle/overview";
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
