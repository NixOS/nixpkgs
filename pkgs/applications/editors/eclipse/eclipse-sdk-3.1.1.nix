{fetchurl, stdenv, makeWrapper, jdk, gtk, glib, libXtst, plugins ? []}:

let {
  body =
    stdenv.mkDerivation {
      name = "eclipse-sdk-3.1.1";
      builder = ./builder.sh;
      src = bindist;
      inherit makeWrapper jdk plugins;
      libraries = [gtk glib libXtst];
   };

  bindist = 
    fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/eclipse-SDK-3.1.1-linux-gtk.tar.gz;
      md5 = "a2ae61431657e2ed247867b9a9948290";
    };
}
