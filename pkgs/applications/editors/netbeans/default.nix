{stdenv, fetchurl, jdk, unzip, which, makeWrapper, makeDesktopItem}:

let
  desktopItem = makeDesktopItem {
    name = "netbeans";
    exec = "netbeans";
    comment = "Integrated Development Environment";
    desktopName = "Netbeans IDE";
    genericName = "Integrated Development Environment";
    categories = "Application;Development;";
  };
in
stdenv.mkDerivation {
  name = "netbeans-7.4";
  src = fetchurl {
    url = http://download.netbeans.org/netbeans/7.4/final/zip/netbeans-7.4-201310111528.zip;
    sha256 = "0nrnghnsdix5cmp86xi1gmvarhjk2k8mlbld3dfa9impm8gpv6mx";
  };
  buildCommand = ''
    # Unpack and copy the stuff
    unzip $src
    mkdir -p $out
    cp -a netbeans $out
    
    # Create a wrapper capable of starting it
    mkdir -p $out/bin
    makeWrapper $out/netbeans/bin/netbeans $out/bin/netbeans \
      --prefix PATH : ${jdk}/bin:${which}/bin \
      --prefix JAVA_HOME : ${jdk}/lib/openjdk \
      --add-flags "--jdkhome ${jdk}/lib/openjdk"
      
    # Create desktop item, so we can pick it from the KDE/GNOME menu
    mkdir -p $out/share/applications
    cp ${desktopItem}/share/applications/* $out/share/applications
  '';
  
  buildInputs = [ unzip makeWrapper ];
  
  meta = {
    description = "An integrated development environment for Java, C, C++ and PHP";
    maintainers = [ stdenv.lib.maintainers.sander ];
  };
}
