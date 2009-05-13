{ stdenv, fetchurl, patchelf, makeDesktopItem
, freetype, fontconfig, libX11, libXext, libXrender
, glib, gtk, libXtst
, jre
}:

stdenv.mkDerivation rec {
  name = "eclipse-3.4.2";
  src = if stdenv.system == "x86_64-linux" then
    fetchurl {
      url = http://ftp.heanet.ie/pub/eclipse/eclipse/downloads/drops/R-3.4.2-200902111700/eclipse-SDK-3.4.2-linux-gtk-x86_64.tar.gz;
      sha256 = "33e4e88347acd7f2f9243a8b887bd012cf5aec06c2d0f64da1349444bbd6876b";
    }
    else
    fetchurl {
      url = http://www.mirrorservice.org/sites/download.eclipse.org/eclipseMirror/eclipse/downloads/drops/R-3.4.2-200902111700/eclipse-SDK-3.4.2-linux-gtk.tar.gz;
      sha256 = "4518992b0d7bafeaa2338017ebc7048b09a227f056f576b2b077a435110ef9dd";
    }
    ;

  desktopItem = makeDesktopItem {
    name = "Eclipse";
    exec = "eclipse";
    icon = "eclipse";
    comment = "Integrated Development Environment";
    desktopName = "Eclipse IDE";
    genericName = "Integrated Development Environment";
    categories = "Application;Development;";
  };

  buildInputs = [ patchelf ];
  buildCommand = ''
    # Unpack tarball
    
    tar xfvz $src
    
    # Patch binaries
    cd eclipse
    ${if stdenv.system == "x86_64-linux" then
        "patchelf --set-interpreter ${stdenv.glibc}/lib/ld-linux-x86-64.so.2 ./eclipse"
      else
        "patchelf --set-interpreter ${stdenv.glibc}/lib/ld-linux.so.2 ./eclipse"
      }
    patchelf --set-rpath ${freetype}/lib:${fontconfig}/lib:${libX11}/lib:${libXext}/lib:${libXrender}/lib ./libcairo-swt.so

    # Create wrapper script
    cd ..
    ensureDir $out/bin
    cp -av eclipse $out
    
    cat > $out/bin/eclipse <<EOF
    #!/bin/sh
    
    export PATH=${jre}/bin
    export LD_LIBRARY_PATH=${glib}/lib:${gtk}/lib:${libXtst}/lib
    
    $out/eclipse/eclipse "\$@"
    EOF
    
    chmod 755 $out/bin/eclipse
    
    # Create desktop item
    
    ensureDir $out/share/applications
    cp ${desktopItem}/share/applications/* $out/share/applications
  '';
}
