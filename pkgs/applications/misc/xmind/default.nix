{ stdenv, fetchurl, makeDesktopItem, makeWrapper
, freetype, fontconfig, libX11, libXext, libXrender, zlib
, glib, gtk, libXtst, jre, unzip
}:

assert stdenv ? glibc;

stdenv.mkDerivation rec {
  name = "xmind-3.5";
  src = fetchurl {
    url = "http://dl2.xmind.net/xmind-downloads/xmind-portable-3.5.0.201410310637.zip";
    sha256 = "dd8bc9e2549b379f4263cbd605c537c0a41c41c668f6b137facbdd90b366cd0c";
  };

  desktopItem = makeDesktopItem {
    name = "XMind";
    exec = "XMind";
    icon = "eclipse";
    comment = "Integrated Development Environment";
    desktopName = "XMind";
    genericName = "Mind Mapper";
    categories = "Application;Development;";
  };
  buildInputs = [ makeWrapper unzip ];

  buildCommand = ''
    # Unpack archive
    unzip -q $src Commons/\* XMind_Linux_64bit/\* -d $out

    # append to startup configuration
    ini=$out/XMind_Linux_64bit/XMind.ini
    echo "-Dosgi.configuration.cascaded=true" >> $ini
    echo "-Dosgi.sharedConfiguration.area=$out/XMind_Linux_64bit/configuration" >> $ini
    echo "-Dosgi.sharedConfiguration.area.readOnly=true" >> $ini

    # Patch binaries.
    interpreter=$(echo ${stdenv.glibc}/lib/ld-linux*.so.2)
    libCairo=$out/XMind_Linux_64bit/libcairo-swt.so
    patchelf --set-interpreter $interpreter $out/XMind_Linux_64bit/XMind
    patchelf --set-rpath ${freetype}/lib:${fontconfig}/lib:${libX11}/lib:${libXrender}/lib:${zlib}/lib $libCairo

    # Create wrapper script.  Pass -configuration to store
    # settings in ~/.eclipse/org.eclipse.platform_<version> rather
    # than ~/.eclipse/org.eclipse.platform_<version>_<number>.
    productId=$(sed 's/id=//; t; d' $out/XMind_Linux_64bit/.eclipseproduct)
    productVersion=$(sed 's/version=//; t; d' $out/XMind_Linux_64bit/.eclipseproduct)

    makeWrapper $out/XMind_Linux_64bit/XMind $out/bin/XMind \
      --prefix PATH : ${jre}/bin \
      --prefix LD_LIBRARY_PATH : ${glib}/lib:${gtk}/lib:${libXtst}/lib \
      --add-flags "-data \$HOME/.xmind" \
      --add-flags "-configuration \$HOME/.eclipse/''${productId}_$productVersion/configuration"

    # Create desktop item.
    mkdir -p $out/share/applications
    cp ${desktopItem}/share/applications/* $out/share/applications
  '';

  meta = {
    homepage = http://www.xmind.net/;
    description = "A mind mapping tool.";
    license = with stdenv.lib.licenses; [lgpl3 epl10];
    maintainers = [ stdenv.lib.maintainers.vandenoever ];
    platforms = ["x86_64-linux"];
  };
}

