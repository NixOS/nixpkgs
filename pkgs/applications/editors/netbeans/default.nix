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
  name = "netbeans-7.2";
  src = fetchurl {
    url = http://download.netbeans.org/netbeans/7.2/final/zip/netbeans-7.2-201207171143-ml.zip;
    sha256 = "18ya1w291hdnc35vb12yqnai82wmqm7351wn82fax12kzha5fmci";
  };
  buildCommand = ''
    # Unpack and copy the stuff
    unzip $src
    mkdir -p $out
    cp -a netbeans $out
    
    # Create a wrapper capable of starting it
    mkdir -p $out/bin
    makeWrapper $out/netbeans/bin/netbeans $out/bin/netbeans \
      --prefix PATH : ${jdk}/bin:${which}/bin
      
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
