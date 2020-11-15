{ stdenv, fetchurl, makeWrapper, makeDesktopItem, which, unzip, libicns, imagemagick
, jdk, perl, python
}:

let
  version = "12.0";
  desktopItem = makeDesktopItem {
    name = "netbeans";
    exec = "netbeans";
    comment = "Integrated Development Environment";
    desktopName = "Apache NetBeans IDE";
    genericName = "Integrated Development Environment";
    categories = "Development;";
    icon = "netbeans";
  };
in
stdenv.mkDerivation {
  pname = "netbeans";
  inherit version;
  src = fetchurl {
    url = "mirror://apache/netbeans/netbeans/${version}/netbeans-${version}-bin.zip";
    sha512 = "91030c9628a08acd85f1a58a7f71eec2e57dc85841c1c475cc6311335b5d8cdc10c1198274b9668b7f61a28d04b07661247dc1c3e36b8e29214aec3748e499e4";
  };

  buildCommand = ''
    # Unpack and perform some path patching.
    unzip $src
    patchShebangs .

    # Copy to installation directory and create a wrapper capable of starting
    # it.
    mkdir -pv $out/bin
    cp -a netbeans $out
    makeWrapper $out/netbeans/bin/netbeans $out/bin/netbeans \
      --prefix PATH : ${stdenv.lib.makeBinPath [ jdk which ]} \
      --prefix JAVA_HOME : ${jdk.home} \
      --add-flags "--jdkhome ${jdk.home}"

    # Extract pngs from the Apple icon image and create
    # the missing ones from the 1024x1024 image.
    icns2png --extract $out/netbeans/nb/netbeans.icns
    for size in 16 24 32 48 64 128 256 512 1024; do
      mkdir -pv $out/share/icons/hicolor/"$size"x"$size"/apps
      if [ -e netbeans_"$size"x"$size"x32.png ]
      then
        mv netbeans_"$size"x"$size"x32.png $out/share/icons/hicolor/"$size"x"$size"/apps/netbeans.png
      else
        convert -resize "$size"x"$size" netbeans_1024x1024x32.png $out/share/icons/hicolor/"$size"x"$size"/apps/netbeans.png
      fi
    done;

    # Create desktop item, so we can pick it from the KDE/GNOME menu
    mkdir -pv $out/share/applications
    ln -s ${desktopItem}/share/applications/* $out/share/applications
  '';

  buildInputs = [ makeWrapper perl python unzip libicns imagemagick ];

  meta = {
    description = "An integrated development environment for Java, C, C++ and PHP";
    homepage = "https://netbeans.apache.org/";
    license = stdenv.lib.licenses.asl20;
    maintainers = with stdenv.lib.maintainers; [ sander rszibele asbachb ];
    platforms = stdenv.lib.platforms.unix;
  };
}
