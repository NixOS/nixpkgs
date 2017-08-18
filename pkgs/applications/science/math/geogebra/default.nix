{ stdenv, fetchurl, jre, makeDesktopItem, makeWrapper }:

stdenv.mkDerivation rec {
  name = "geogebra-${version}";
  version = "5-0-382-0";

  preferLocalBuild = true;

  src = fetchurl {
    urls = [
      "http://download.geogebra.org/installers/5.0/GeoGebra-Linux-Portable-${version}.tar.bz2"

      # Fallback for 5-0-382-0
      # To avoid breaks when latest geogebra version is
      # removed from `download.geogebra.org`
      "http://web.archive.org/web/20170818191250/http://download.geogebra.org/installers/5.0/GeoGebra-Linux-Portable-5-0-382-0.tar.bz2"
    ];
    sha256 = "0xqln1ssm35q8ry4a0ly8rkgw41brmrhn26l6q6r0qqrnw85cnyv";
  };

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
    categories = "Education;Science;Math;";
    mimeType = "application/vnd.geogebra.file;application/vnd.geogebra.tool;";
  };

  buildInputs = [ makeWrapper ];

  installPhase = ''
    install -D geogebra/* -t "$out/libexec/geogebra/"

    makeWrapper "$out/libexec/geogebra/geogebra" "$out/bin/geogebra" \
      --set JAVACMD "${jre}/bin/java" \
      --set GG_PATH "$out/libexec/geogebra"

    install -Dm644 "${desktopItem}/share/applications/"* \
      -t $out/share/applications/

    install -Dm644 "${srcIcon}" \
      "$out/share/icons/hicolor/scalable/apps/geogebra.svg"
  '';

  meta = with stdenv.lib; {
    description = "Dynamic mathematics software with graphics, algebra and spreadsheets";
    longDescription = ''
      Dynamic mathematics software for all levels of education that brings
      together geometry, algebra, spreadsheets, graphing, statistics and
      calculus in one easy-to-use package.
    '';
    homepage = https://www.geogebra.org/;
    maintainers = with maintainers; [ ma27 ];
    license = with licenses; [ gpl3 cc-by-nc-sa-30 geogebra ];
    platforms = platforms.all;
    hydraPlatforms = [];
  };
}
