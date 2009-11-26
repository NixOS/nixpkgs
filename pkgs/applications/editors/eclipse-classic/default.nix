{ stdenv, fetchurl, patchelf, makeDesktopItem, makeWrapper
, freetype, fontconfig, libX11, libXext, libXrender, zlib
, glib, gtk, libXtst, jre
}:

assert stdenv ? glibc;

stdenv.mkDerivation rec {
  name = "eclipse-3.5.1";
  
  src =
    if stdenv.system == "x86_64-linux" then
      fetchurl {
        url = http://ftp.ing.umu.se/mirror/eclipse/eclipse/downloads/drops/R-3.5.1-200909170800/eclipse-SDK-3.5.1-linux-gtk-x86_64.tar.gz;
        sha256 = "132zd7q9q29h978wnlsfbrlszc85r1wj30yqs2aqbv3l5xgny1kk";
      }
    else
      fetchurl {
        url = http://mirrors.linux-bg.org/eclipse/eclipse/downloads/drops/R-3.5.1-200909170800/eclipse-SDK-3.5.1-linux-gtk.tar.gz;
        sha256 = "0a0lpa7gxg91zswpahi6fvg3csl4csvlym4z2ad5cc1d4yvicp56";
      };

  desktopItem = makeDesktopItem {
    name = "Eclipse";
    exec = "eclipse";
    icon = "eclipse";
    comment = "Integrated Development Environment";
    desktopName = "Eclipse IDE";
    genericName = "Integrated Development Environment";
    categories = "Application;Development;";
  };

  buildInputs = [ makeWrapper patchelf ];
  
  buildCommand = ''
    # Unpack tarball
    ensureDir $out
    tar xfvz $src -C $out
    
    # Patch binaries
    interpreter=$(echo ${stdenv.glibc}/lib/ld-linux*.so.2)
    patchelf --set-interpreter $interpreter $out/eclipse/eclipse
    patchelf --set-rpath ${freetype}/lib:${fontconfig}/lib:${libX11}/lib:${libXrender}/lib:${zlib}/lib $out/eclipse/libcairo-swt.so

    # Create wrapper script
    makeWrapper $out/eclipse/eclipse $out/bin/eclipse \
      --prefix PATH : ${jre}/bin \
      --prefix LD_LIBRARY_PATH : ${glib}/lib:${gtk}/lib:${libXtst}/lib
    
    # Create desktop item
    ensureDir $out/share/applications
    cp ${desktopItem}/share/applications/* $out/share/applications
  '';
}
