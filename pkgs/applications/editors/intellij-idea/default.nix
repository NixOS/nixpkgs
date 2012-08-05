{ stdenv, fetchurl, patchelf, makeDesktopItem, ant, jdk } :

stdenv.mkDerivation rec {
    name = "intellij-idea-ce-11";
    description = "IntelliJ IDEA Community Edition version 11.1.69";
    
    src = fetchurl {
            url = http://download.jetbrains.com/idea/ideaIC-11-src.tar.bz2;
            sha256 = "0wyq4n8gz473kvxz9n8l16c0chscqvj95k4jdbga9b60n59987vr";
          };
    
    builder = ./builder.sh;

    desktopItem = makeDesktopItem {
                    name = "IntelliJ-IDEA-CE";
                    exec = "idea.sh";
                    icon = "idea_CE128.png";
                    comment = "IntelliJ IDEA Community Edition";
                    desktopName = "IntelliJ IDEA CE";
                    genericName = "IntelliJ IDEA Community Edition";
                    categories = "Application;Development;";
                  };

    # TODO(corey): I'm confused on how to provide both the architecture's dynamic linker path.
    notifierToPatch = if stdenv.system == "x86_64-linux" 
                        then "fsnotifier64" 
                        else "fsnotifier";

    inherit ant jdk;
}

