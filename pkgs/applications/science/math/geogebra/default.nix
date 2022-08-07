{ lib, stdenv, fetchurl, jre, makeDesktopItem, makeWrapper, unzip, language ? "en_US" }:
let
  pname = "geogebra";
  version = "5-0-706-0";

  srcIcon = fetchurl {
    url = "http://static.geogebra.org/images/geogebra-logo.svg";
    sha256 = "01sy7ggfvck350hwv0cla9ynrvghvssqm3c59x4q5lwsxjsxdpjm";
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
        "https://web.archive.org/web/20220516130744/https://download.geogebra.org/installers/5.0/GeoGebra-Linux-Portable-${version}.tar.bz2"
      ];
      sha256 = "d18f3d20baff693606331f035fa4bf73e7418d28090f038054da98444b06f69b";
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
        "https://download.geogebra.org/installers/5.0/GeoGebra-MacOS-Installer-withJava-${version}.zip"
        "https://web.archive.org/web/20220516132502/https://download.geogebra.org/installers/5.0/GeoGebra-MacOS-Installer-withJava-${version}.zip"
      ];
      sha256 = "0070ec8d8d5f79c921b5d7433048c2c114ec4b812d839bb04e67848fce24ee0a";
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
