{ stdenv, fetchurl, makeWrapper, makeDesktopItem
, gawk, jdk, perl, python, unzip, which
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
  name = "netbeans-8.1";
  src = fetchurl {
    url = http://download.netbeans.org/netbeans/8.1/final/zip/netbeans-8.1-201510222201.zip;
    sha256 = "1aaf132mndpgfbd5v8izqzp37hjs5gwqwd6zrb519fx0viz9aq5r";
  };

  buildCommand = ''
    # Unpack and perform some path patching.
    unzip $src
    patch -p1 <${./path.patch}
    substituteInPlace netbeans/platform/lib/nbexec \
        --subst-var-by AWK ${gawk}/bin/awk
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
