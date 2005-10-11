{fetchurl, stdenv, makeWrapper, jdk, gtk, glib, libXtst}:

let {
  body =
    stdenv.mkDerivation {
      name = "eclipse-sdk-3.1.1";
      builder = ./builder.sh;
      src = bindist;
      inherit makeWrapper jdk;
      libraries = [gtk glib libXtst];
   };

  bindist = 
    fetchurl {
      url = http://sunsite.informatik.rwth-aachen.de/eclipse/downloads/drops/R-3.1.1-200509290840/eclipse-SDK-3.1.1-linux-gtk.tar.gz;
      md5 = "a2ae61431657e2ed247867b9a9948290";
    };
}
