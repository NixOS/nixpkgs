{ stdenv, fetchurl, jre, makeDesktopItem, makeWrapper }:

stdenv.mkDerivation rec {
  name = "geogebra-${version}";
  version = "5.0.271.0";

  preferLocalBuild = true;

  src = fetchurl {
    url = "http://download.geogebra.org/installers/5.0/GeoGebra-Linux-Portable-${version}.tar.bz2";
    sha256 = "5dd5be1cde27c9b567f79c38048045864064b69c0d2b469ae93e1fca5f543475";
  };

  srcIcon = fetchurl {
    url = "http://static.geogebra.org/images/geogebra-logo.svg";
    sha256 = "55ded6b5ec9ad382494f858d8ab5def0ed6c7d529481cd212863b2edde3b5e07";
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
    license = with licenses; [ gpl3 cc-by-nc-sa-30 geogebra ];
    platforms = platforms.all;
    hydraPlatforms = [];
  };
}
