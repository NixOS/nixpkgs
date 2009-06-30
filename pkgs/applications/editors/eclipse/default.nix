# recommended installation:
# nix-build -A eclipsesdk
# then cp -r $store-path ~/my-eclipse; chmod -R 777 ~/my-eclipse # ugh! I'm to lazy to assign permissions properly
# maybe also using a wrapper such as this (lower values should suffice for most needs)
#  eclipseWrapper () {
#     "$@" -vmargs -Xms2048m -Xmx2048m -XX:MaxPermSize=2048m
# }
#
# Why use a local copy? This way it's easier to use the update manager to get plugins :-)


{fetchurl, stdenv, jdk, gtk, glib, libXtst, makeOverridable, plugins ? [], unzip}:

let eclipseFun = 
  makeOverridable ({name, bindist} :
    stdenv.mkDerivation {
      inherit name;
      builder = ./builder.sh;
      src = bindist;
      buildInputs = [ unzip /* unzip required by eclipseCDT */ ];
      inherit jdk plugins;
      libraries = [gtk glib libXtst];
   }); in

  eclipseFun {
    # you can override these settings usnig .override {...} 
    name = "eclipse-sdk-3.5M6";

    bindist = 
      if (stdenv.system == "x86_64-linux") then fetchurl {
        url = http://download.eclipse.org/eclipse/downloads/drops/N20090621-2000/eclipse-SDK-N20090621-2000-linux-gtk-x86_64.tar.gz;
        sha256 = "1nzrc7dplf7xzmq3282ysgar0a2jbm2y0vz8yf707da84n60yvg7";
      } else fetchurl {
        url = ftp://mirror.micromata.de/eclipse/eclipse/downloads/drops/S-3.5M6-200903130100/eclipse-SDK-3.5M6-linux-gtk.tar.gz;
        sha256 = "1z8j26b632ydhqrmwgbcqgiq7f1a542jam06z2h62mcbqazrcyah";
      };
  }

#/nix/store/rzmaas0m5q5gr1343gx2abs4lg832ml4-eclipse-SDK-N20090621-2000-linux-gtk-x86_64.tar.gz
