{ lib
, stdenv
, fetchurl
, makeWrapper
, makeDesktopItem
, which
, unzip
, libicns
, imagemagick
, jdk
, copyDesktopItems
}:

stdenv.mkDerivation rec {
  pname = "tmcbeans";
  version = "1.4.0";
  src = fetchurl {
    url = "https://download.mooc.fi/tmcbeans/installers/tmcbeans_${version}.zip";
    hash = "sha512-kugZ7DAarbKK8RvOx7VYIpCwNhm3QVBlvqy+R7oeDDTT0LeDtHsWNIpIQSgT7t9MExfG1X9bqCqspJwYQxUG5g==";
  };

  installPhase = ''
    runHook preInstall

    find -name \*.exe -exec rm -f {} \;

    # Copy to installation directory
    mkdir -pv $out/tmcbeans
    cp -a . $out/tmcbeans

    runHook postInstall
  '';

  postInstall = ''
    mkdir -pv $out/bin
    makeWrapper $out/tmcbeans/bin/tmcbeans $out/bin/tmcbeans \
      --prefix PATH : ${lib.makeBinPath [ jdk  which ]} \
      --prefix JAVA_HOME : ${jdk.home} \
      --add-flags "-J-Dawt.useSystemAAFontSettings=on" \
      --add-flags "-J-Dswing.aatext=true"

    # Extract pngs from the Apple icon image and create
    # the missing ones from the 1024x1024 image.
    icns2png --extract $out/tmcbeans/nb/tmcbeans.icns
    for size in 16 24 32 48 64 128 256 512 1024; do
      mkdir -pv $out/share/icons/hicolor/"$size"x"$size"/apps
      if [ -e tmcbeans_"$size"x"$size"x32.png ]
      then
        mv tmcbeans_"$size"x"$size"x32.png $out/share/icons/hicolor/"$size"x"$size"/apps/tmcbeans.png
      else
        convert -resize "$size"x"$size" $out/tmcbeans/nb/tmcbeans.png $out/share/icons/hicolor/"$size"x"$size"/apps/tmcbeans.png
      fi
    done;
  '';

  nativeBuildInputs = [ makeWrapper unzip copyDesktopItems ];
  buildInputs = [ libicns imagemagick ];

  desktopItems = [ (makeDesktopItem {
    name = "tmcbeans";
    exec = "tmcbeans";
    comment = "Apache Netbeans IDE with TMC integration";
    desktopName = "TMCBeans";
    genericName = "Integrated Development Environment";
    categories = [ "Development" ];
    icon = "tmcbeans";
  }) ];

  meta = with lib; {
    description = "A customized version of the Netbeans IDE for Java, C, C++ and PHP with the Test My Code system installed";
    homepage = "https://www.mooc.fi";
    license = licenses.asl20;
    maintainers = with maintainers; [ robbins ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
