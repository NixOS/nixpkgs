{ lib, stdenv, fetchurl, jre, makeDesktopItem, makeWrapper, unzip, language ? "en_US" }:
let
  pname = "geogebra";
  version = "5-0-785-0";

  srcIcon = fetchurl {
    url = "http://static.geogebra.org/images/geogebra-logo.svg";
    hash = "sha256-Vd7Wteya04JJT4WNirXe8O1sfVKUgc0hKGOy7d47Xgc=";
  };

  desktopItem = makeDesktopItem {
    name = "geogebra";
    exec = "geogebra";
    icon = "geogebra";
    desktopName = "Geogebra";
    genericName = "Geogebra";
    comment = meta.description;
    categories = [ "Education" "Science" "Math" ];
    mimeTypes = [ "application/vnd.geogebra.file" "application/vnd.geogebra.tool" ];
  };

  meta = with lib; {
    description = "Dynamic mathematics software with graphics, algebra and spreadsheets";
    longDescription = ''
      Dynamic mathematics software for all levels of education that brings
      together geometry, algebra, spreadsheets, graphing, statistics and
      calculus in one easy-to-use package.
    '';
    homepage = "https://www.geogebra.org/";
    maintainers = with maintainers; [ sikmir imsofi ];
    license = with licenses; [ gpl3 cc-by-nc-sa-30 geogebra ];
    sourceProvenance = with sourceTypes; [
      binaryBytecode
      binaryNativeCode  # some jars include native binaries
    ];
    platforms = with platforms; linux ++ darwin;
    hydraPlatforms = [];
  };

  linuxPkg = stdenv.mkDerivation {
    inherit pname version meta srcIcon desktopItem;

    preferLocalBuild = true;

    src = fetchurl {
      urls = [
        "https://download.geogebra.org/installers/5.0/GeoGebra-Linux-Portable-${version}.tar.bz2"
        "https://web.archive.org/web/20230627211902/https://download.geogebra.org/installers/5.0/GeoGebra-Linux-Portable-${version}.tar.bz2"
      ];
      hash = "sha256-cL4ERKZpE9Y6IdOjvYiX3nIIW3E2qoqkpMyTszvFseM=";
    };

    nativeBuildInputs = [ makeWrapper ];

    installPhase = ''
      install -D geogebra/* -t "$out/libexec/geogebra/"

      makeWrapper "$out/libexec/geogebra/geogebra" "$out/bin/geogebra" \
        --set JAVACMD "${jre}/bin/java" \
        --set GG_PATH "$out/libexec/geogebra" \
        --add-flags "--language=${language}"

      install -Dm644 "${desktopItem}/share/applications/"* \
        -t $out/share/applications/

      install -Dm644 "${srcIcon}" \
        "$out/share/icons/hicolor/scalable/apps/geogebra.svg"
    '';
  };

  darwinPkg = stdenv.mkDerivation {
    inherit pname version meta;

    preferLocalBuild = true;

    src = fetchurl {
      urls = [
        "https://download.geogebra.org/installers/5.0/GeoGebra-MacOS-Installer-withJava-${version}-x64.zip"
        "https://web.archive.org/web/20230627211427/https://download.geogebra.org/installers/5.0/GeoGebra-MacOS-Installer-withJava-${version}-x64.zip"
      ];
      hash = "sha256-KHjNH8c3/aMJ5CcwCwW9z0QRxJwqYU5I610zpMMruBQ=";
    };

    dontUnpack = true;

    nativeBuildInputs = [ unzip ];

    installPhase = ''
      install -dm755 $out/Applications
      unzip $src -d $out/Applications
    '';
  };
in
if stdenv.isDarwin
then darwinPkg
else linuxPkg
