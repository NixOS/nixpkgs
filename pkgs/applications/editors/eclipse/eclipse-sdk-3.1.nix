{fetchurl, stdenv, makeWrapper, jdk, gtk, glib, libXtst}:

let {
  body =
    stdenv.mkDerivation {
      name = "eclipse-sdk-3.1";
      builder = ./builder.sh;
      src = bindist;
      inherit makeWrapper jdk;
      libraries = [gtk glib libXtst];
   };

  bindist = 
    fetchurl {
      url = http://sunsite.informatik.rwth-aachen.de/eclipse/downloads/drops/R-3.1-200506271435/eclipse-SDK-3.1-linux-gtk.tar.gz;
      md5 = "0441c11cc5af1e84ed3be322929899e8";
    };
}
