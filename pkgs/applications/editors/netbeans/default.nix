{ stdenv, fetchurl, makeWrapper, makeDesktopItem, which, unzip, libicns, imagemagick
, jdk, perl, python
}:

let
  version = "11.0";
  desktopItem = makeDesktopItem {
    name = "netbeans";
    exec = "netbeans";
    comment = "Integrated Development Environment";
    desktopName = "Netbeans IDE";
    genericName = "Integrated Development Environment";
    categories = "Application;Development;";
    icon = "netbeans";
  };
in
stdenv.mkDerivation {
  pname = "netbeans";
  inherit version;
  src = fetchurl {
    url = "mirror://apache/incubator/netbeans/incubating-netbeans/incubating-${version}/incubating-netbeans-${version}-bin.zip";
    sha512 = "15mv59njrnq3sjfzb0n7xcc79kpixygf37cxvbswnvm651cw6lb1i9w8wbjivh0z4zcf3f62vbmshxh5pkaxqpqsg0iyy6gddfbwzwx";
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
    homepage = "https://netbeans.org/";
    license = stdenv.lib.licenses.asl20;
    maintainers = with stdenv.lib.maintainers; [ sander rszibele ];
    platforms = stdenv.lib.platforms.unix;
  };
}
