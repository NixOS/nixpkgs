{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  makeDesktopItem,
  which,
  unzip,
  libicns,
  imagemagick,
  jdk21,
  perl,
}:

let
  version = "24";
  desktopItem = makeDesktopItem {
    name = "netbeans";
    exec = "netbeans";
    comment = "Integrated Development Environment";
    desktopName = "Apache NetBeans IDE";
    genericName = "Integrated Development Environment";
    categories = [ "Development" ];
    icon = "netbeans";
  };
in
stdenv.mkDerivation {
  pname = "netbeans";
  inherit version;
  src = fetchurl {
    url = "mirror://apache/netbeans/netbeans/${version}/netbeans-${version}-bin.zip";
    hash = "sha256-mzmviZuyS68SZhOAzwWOdZLveOTS5UOgY1oW+oAv9Gs=";
  };

  buildCommand = ''
    # Unpack and perform some path patching.
    unzip $src
    patchShebangs .

    rm netbeans/bin/*.exe

    # Copy to installation directory and create a wrapper capable of starting
    # it.
    mkdir -pv $out/bin
    cp -a netbeans $out
    makeWrapper $out/netbeans/bin/netbeans $out/bin/netbeans \
      --prefix PATH : ${
        lib.makeBinPath [
          jdk21
          which
        ]
      } \
      --prefix JAVA_HOME : ${jdk21.home} \
      --add-flags "--jdkhome ${jdk21.home} \
      -J-Dawt.useSystemAAFontSettings=on -J-Dswing.aatext=true"

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

  nativeBuildInputs = [
    makeWrapper
    unzip
  ];
  buildInputs = [
    perl
    libicns
    imagemagick
  ];

  meta = {
    description = "Integrated development environment for Java, C, C++ and PHP";
    homepage = "https://netbeans.apache.org/";
    license = lib.licenses.asl20;
    sourceProvenance = with lib.sourceTypes; [
      binaryBytecode
      binaryNativeCode
    ];
    maintainers = with lib.maintainers; [
      sander
      rszibele
      kashw2
    ];
    platforms = lib.platforms.unix;
    mainProgram = "netbeans";
  };
}
