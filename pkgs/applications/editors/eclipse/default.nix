{fetchurl, stdenv, makeWrapper, jdk, gtk, glib, libXtst, plugins ? []}:

let {
  body =
    stdenv.mkDerivation {
      name = "eclipse-sdk-3.3.2";
      builder = ./builder.sh;
      src = bindist;
      buildInputs = [makeWrapper];
      inherit jdk plugins;
      libraries = [gtk glib libXtst];
   };

  bindist = 
    if (stdenv.system == "x86_64-linux") then fetchurl {
      url = http://ftp-stud.fht-esslingen.de/pub/Mirrors/eclipse/eclipse/downloads/drops/R-3.3.2-200802211800/eclipse-SDK-3.3.2-linux-gtk-x86_64.tar.gz;
      sha256 = "fa7ff6fd17d053a53f743fa3d79493aa2e359402563cc736db9709a87826af21";
    } else fetchurl {
      url = http://ftp-stud.fht-esslingen.de/pub/Mirrors/eclipse/eclipse/downloads/drops/R-3.3.2-200802211800/eclipse-SDK-3.3.2-linux-gtk.tar.gz;
      sha256 = "624460c87f763b855fcddca86d969f2e4c730e654fe1a0dd69624afe576b13c8";
    };
}
