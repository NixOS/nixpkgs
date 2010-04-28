{ stdenv, fetchurl, patchelf, makeDesktopItem, makeWrapper
, freetype, fontconfig, libX11, libXext, libXrender, zlib
, glib, gtk, libXtst, jre
}:

assert stdenv ? glibc;

stdenv.mkDerivation rec {
  name = "eclipse-3.5.2";
  
  src =
    if stdenv.system == "x86_64-linux" then
      fetchurl {
        url = http://ftp-stud.fht-esslingen.de/pub/Mirrors/eclipse/eclipse/downloads/drops/R-3.5.2-201002111343/eclipse-SDK-3.5.2-linux-gtk-x86_64.tar.gz;
        md5 = "54e2ce0660b2b1b0eb4267acf70ea66d";
      }
    else
      fetchurl {
        url = http://mirror.selfnet.de/eclipse/eclipse/downloads/drops/R-3.5.2-201002111343/eclipse-SDK-3.5.2-linux-gtk.tar.gz;
        md5 = "bde55a2354dc224cf5f26e5320e72dac";
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

  meta = {
    homepage = http://www.eclipse.org/;
    description = "A extensible multi-language software development environment";
    longDescription = ''
    '';
  };
}
