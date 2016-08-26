{ stdenv, makeDesktopItem, freetype, fontconfig, libX11, libXrender, zlib, jdk, glib, gtk, libXtst, webkitgtk2, makeWrapper, ... }:

{ name, src ? builtins.getAttr stdenv.system sources, sources ? null, description }:

stdenv.mkDerivation rec {
  inherit name src;

  desktopItem = makeDesktopItem {
    name = "Eclipse";
    exec = "eclipse";
    icon = "eclipse";
    comment = "Integrated Development Environment";
    desktopName = "Eclipse IDE";
    genericName = "Integrated Development Environment";
    categories = "Application;Development;";
  };

  buildInputs = [ makeWrapper ];

  buildCommand = ''
    # Unpack tarball.
    mkdir -p $out
    tar xfvz $src -C $out

    # Patch binaries.
    interpreter=$(echo ${stdenv.glibc.out}/lib/ld-linux*.so.2)
    libCairo=$out/eclipse/libcairo-swt.so
    patchelf --set-interpreter $interpreter $out/eclipse/eclipse
    [ -f $libCairo ] && patchelf --set-rpath ${stdenv.lib.makeLibraryPath [ freetype fontconfig libX11 libXrender zlib ]} $libCairo

    # Create wrapper script.  Pass -configuration to store
    # settings in ~/.eclipse/org.eclipse.platform_<version> rather
    # than ~/.eclipse/org.eclipse.platform_<version>_<number>.
    productId=$(sed 's/id=//; t; d' $out/eclipse/.eclipseproduct)
    productVersion=$(sed 's/version=//; t; d' $out/eclipse/.eclipseproduct)

    makeWrapper $out/eclipse/eclipse $out/bin/eclipse \
      --prefix PATH : ${jdk}/bin \
      --prefix LD_LIBRARY_PATH : ${stdenv.lib.makeLibraryPath ([ glib gtk libXtst ] ++ stdenv.lib.optional (webkitgtk2 != null) webkitgtk2)} \
      --add-flags "-configuration \$HOME/.eclipse/''${productId}_$productVersion/configuration"

    # Create desktop item.
    mkdir -p $out/share/applications
    cp ${desktopItem}/share/applications/* $out/share/applications
    mkdir -p $out/share/pixmaps
    ln -s $out/eclipse/icon.xpm $out/share/pixmaps/eclipse.xpm
  ''; # */

  meta = {
    homepage = http://www.eclipse.org/;
    inherit description;
  };

}
