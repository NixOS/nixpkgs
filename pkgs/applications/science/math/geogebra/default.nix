{ stdenv, fetchurl, jre, makeDesktopItem, makeWrapper, language ? "en_US" }:

stdenv.mkDerivation rec {
  pname = "geogebra";
  version = "5-0-574-0";

  preferLocalBuild = true;

  src = fetchurl {
    urls = [
      "https://download.geogebra.org/installers/5.0/GeoGebra-Linux-Portable-${version}.tar.bz2"
      "http://web.archive.org/https://download.geogebra.org/installers/5.0/GeoGebra-Linux-Portable-${version}.tar.bz2"
    ];
    sha256 = "0jbci4spqkf33yb079lsnsc684y4mdf1p8lm9r0037av8jlsrgrc";
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
      --set GG_PATH "$out/libexec/geogebra" \
      --add-flags "--language=${language}"

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
