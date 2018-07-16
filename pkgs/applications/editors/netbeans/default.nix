{ stdenv, fetchurl, makeWrapper, makeDesktopItem
, jdk, perl, python, unzip, which
}:

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
  name = "netbeans-8.2";
  src = fetchurl {
    url = https://download.netbeans.org/netbeans/8.2/final/zip/netbeans-8.2-201609300101.zip;
    sha256 = "0j092qw7aqfc9vpnvr3ix1ii94p4ik6frcnw708iyv4s9crqi65d";
  };

  buildCommand = ''
    # Unpack and perform some path patching.
    unzip $src
    patchShebangs .

    # Copy to installation directory and create a wrapper capable of starting
    # it.
    mkdir -p $out/bin
    cp -a netbeans $out
    makeWrapper $out/netbeans/bin/netbeans $out/bin/netbeans \
      --prefix PATH : ${stdenv.lib.makeBinPath [ jdk which ]} \
      --prefix JAVA_HOME : ${jdk.home} \
      --add-flags "--jdkhome ${jdk.home}"

    # Create desktop item, so we can pick it from the KDE/GNOME menu
    mkdir -p $out/share/applications
    cp ${desktopItem}/share/applications/* $out/share/applications
  '';

  buildInputs = [ makeWrapper perl python unzip ];

  meta = {
    description = "An integrated development environment for Java, C, C++ and PHP";
    maintainers = [ stdenv.lib.maintainers.sander ];
    platforms = stdenv.lib.platforms.unix;
  };
}
