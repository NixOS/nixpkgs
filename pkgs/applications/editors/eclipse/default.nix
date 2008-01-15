{fetchurl, stdenv, makeWrapper, jdk, gtk, glib, libXtst, plugins ? []}:

let {
  body =
    stdenv.mkDerivation {
      name = "eclipse-sdk-3.3.3.1";
      builder = ./builder.sh;
      src = bindist;
      inherit makeWrapper jdk plugins;
      libraries = [gtk glib libXtst];
   };

  bindist = 
    if (stdenv.system == "x86_64-linux") then fetchurl {
      url = "http://ftp-stud.fht-esslingen.de/pub/Mirrors/eclipse/eclipse/downloads/drops/R-3.3.1.1-200710231652/eclipse-SDK-3.3.1.1-linux-gtk-x86_64.tar.gz";
      sha256 = "3fec49e95c45b56ad77b2bd15616af9d1fa6c3b338d4c70b497ecdc974c0b030";
    } else fetchurl {
      url = http://ftp-stud.fht-esslingen.de/pub/Mirrors/eclipse/eclipse/downloads/drops/R-3.3.1.1-200710231652/eclipse-SDK-3.3.1.1-linux-gtk.tar.gz;
      sha256 = "409e47745c92ff8ea8b2037104ec90c2f8ce3edb3563fdb312d55e1bbd2ada01";
    };
}
