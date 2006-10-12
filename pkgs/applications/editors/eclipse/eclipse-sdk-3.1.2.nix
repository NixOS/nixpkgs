{fetchurl, stdenv, makeWrapper, jdk, gtk, glib, libXtst, plugins ? []}:

let {
  body =
    stdenv.mkDerivation {
      name = "eclipse-sdk-3.1.2";
      builder = ./builder.sh;
      src = bindist;
      inherit makeWrapper jdk plugins;
      libraries = [gtk glib libXtst];
   };

  bindist = 
    fetchurl {
      url = http://archive.eclipse.org/eclipse/downloads/drops/R-3.1.2-200601181600/eclipse-SDK-3.1.2-linux-gtk.tar.gz;
      md5 = "ece50ed4d6d48dac839bfe8fa719fcff";
    };
}
