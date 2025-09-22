{
  lib,
  stdenvNoCC,
  fetchurl,
  jre8,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
}:

stdenvNoCC.mkDerivation rec {
  pname = "jflap";
  version = "7.1";

  src = fetchurl {
    url = "https://www.jflap.org/jflaptmp/july27-18/JFLAP${version}.jar";
    sha256 = "oiwJXdxWsYFj6Ovu7xZbOgTLVw8160a5YQUWbgbJlAY=";
  };

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
  ];

  buildInputs = [
    jre8
  ];

  dontUnpack = true;

  desktopItems = [
    (makeDesktopItem {
      name = "jflap";
      desktopName = "jflap";
      genericName = "Formal language application";
      exec = "jflap";
      icon = fetchurl {
        url = "https://www.jflap.org/jflapLogo2.jpg";
        sha256 = "sha256-IiworHI+GT6Fm6B0E+FXnKe+hN8nZYPrxHGZFAcsWDw=";
      };
      comment = meta.description;
      categories = [
        "Development"
        "Education"
        "ComputerScience"
        "DataVisualization"
        "Engineering"
        "Java"
      ];
    })
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/java
    cp -s $src $out/share/java/jflap.jar
    makeWrapper ${jre8}/bin/java $out/bin/jflap \
      --prefix _JAVA_OPTIONS " " "-Dawt.useSystemAAFontSettings=gasp" \
      --add-flags "-jar $out/share/java/jflap.jar"
    runHook postInstall
  '';

  meta = with lib; {
    description = "GUI tool for experimenting with formal languages topics";
    homepage = "https://www.jflap.org/";
    license = licenses.unfree;
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    maintainers = with maintainers; [
      grnnja
    ];
    platforms = jre8.meta.platforms;
  };
}
