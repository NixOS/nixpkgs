# recommended installation:
# nix-build -A eclipsesdk
# then cp -r $store-path ~/my-eclipse; chmod -R 777 ~/my-eclipse # ugh! I'm to lazy to assign permissions properly
# maybe also using a wrapper such as this (lower values should suffice for most needs)
#  eclipseWrapper () {
#     "$@" -vmargs -Xms2048m -Xmx2048m -XX:MaxPermSize=2048m
# }
#
# Why use a local copy? This way it's easier to use the update manager to get plugins :-)


{fetchurl, stdenv, jdk, gtk, glib, libXtst, plugins ? []}:

let {
  body =
    stdenv.mkDerivation {
      name = "eclipse-sdk-3.5M6";
      builder = ./builder.sh;
      src = bindist;
      buildInputs = [];
      inherit jdk plugins;
      libraries = [gtk glib libXtst];
   };

  bindist = 
    if (stdenv.system == "x86_64-linux") then fetchurl {
      url = ftp://sunsite.informatik.rwth-aachen.de/pub/mirror/eclipse/S-3.5M6-200903130100/eclipse-SDK-3.5M6-linux-gtk-x86_64.tar.gz;
      sha256 = "10p4idp5rcdf7xqwfk3kvmjxhi8x1v835m0y4pn9q4nhfb5643pi";
    } else fetchurl {
      url = ftp://mirror.micromata.de/eclipse/eclipse/downloads/drops/S-3.5M6-200903130100/eclipse-SDK-3.5M6-linux-gtk.tar.gz;
      sha256 = "1z8j26b632ydhqrmwgbcqgiq7f1a542jam06z2h62mcbqazrcyah";
    };
}
