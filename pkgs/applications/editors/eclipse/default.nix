{fetchurl, stdenv, makeWrapper, jdk, gtk, glib, libXtst, plugins ? []}:

let {
  body =
    stdenv.mkDerivation {
      name = "eclipse-sdk-3.2.2";
      builder = ./builder.sh;
      src = bindist;
      inherit makeWrapper jdk plugins;
      libraries = [gtk glib libXtst];
   };

  bindist = 
    fetchurl {
      url = http://ftp-stud.fht-esslingen.de/pub/Mirrors/eclipse/eclipse/downloads/drops/R-3.2.2-200702121330/eclipse-SDK-3.2.2-linux-gtk.tar.gz;
      sha256 = "0slrx8l75k91v8hqr2rvh6x0a2xdplza8gm1dc39bhyaq2gx9sdx";
    };
}


