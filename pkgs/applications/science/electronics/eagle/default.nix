{ stdenv, fetchurl, makeDesktopItem, patchelf, zlib, freetype, fontconfig
, openssl, libXrender, libXrandr, libXcursor, libX11, libXext, libXi
}:

let

  libPath = stdenv.lib.makeLibraryPath
    [ zlib freetype fontconfig openssl libXrender libXrandr libXcursor libX11
      libXext libXi
    ];

in

stdenv.mkDerivation rec {
  name = "eagle-${version}";
  version = "6.5.0";

  src = fetchurl {
    url = "ftp://ftp.cadsoft.de/eagle/program/6.5/eagle-lin-${version}.run";
    sha256 = "17plwx2p8q2ylk0nzj5crfbdm7jc35pw7v3j8f4j81yl37l7bj22";
  };

  desktopItem = makeDesktopItem {
    name = "eagle";
    exec = "eagle";
    icon = "eagle";
    comment = "Schematic capture and PCB layout";
    desktopName = "Eagle";
    genericName = "Schematic editor";
    categories = "Application;Development;";
  };

  buildInputs =
    [ patchelf zlib freetype fontconfig openssl libXrender libXrandr libXcursor
      libX11 libXext libXi
    ];

  phases = [ "installPhase" ];

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
    gcc -shared -fPIC -DEAGLE_PATH=\"$out/eagle-${version}\" ${./eagle_fixer.c} -o "$out"/lib/eagle_fixer.so -ldl

    # Make wrapper script
    dynlinker="$(cat $NIX_CC/nix-support/dynamic-linker)"
    mkdir -p "$out"/bin
    cat > "$out"/bin/eagle << EOF
    #!${stdenv.shell}
    export LD_LIBRARY_PATH="${stdenv.cc.gcc}/lib:${libPath}"
    export LD_PRELOAD="$out/lib/eagle_fixer.so"
    exec "$dynlinker" "$out/eagle-${version}/bin/eagle" "\$@"
    EOF
    chmod a+x "$out"/bin/eagle

    # Make desktop item
    mkdir -p "$out"/share/applications
    cp "$desktopItem"/share/applications/* "$out"/share/applications/
    mkdir -p "$out"/share/icons
    ln -s "$out/eagle-${version}/bin/eagleicon50.png" "$out"/share/icons/eagle.png
  '';

  meta = with stdenv.lib; {
    description = "Schematic editor and PCB layout tool from CadSoft";
    homepage = http://www.cadsoftusa.com/;
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
