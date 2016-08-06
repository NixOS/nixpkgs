{stdenv, fetchurl, jre, makeDesktopItem}:

stdenv.mkDerivation rec {
  name = "geogebra-${version}";
  version = "5.0.265.0";

  srcs = [
    (fetchurl {
      url = "http://download.geogebra.org/installers/5.0/GeoGebra-Linux-Portable-${version}.tar.bz2";
      sha256 = "74e5abfa098ee0fc464cd391cd3ef6db474ff25e8ea4fbcd82c4b4b5d3d5c459";
    })
    (fetchurl {
      url = "http://static.geogebra.org/images/geogebra-logo.svg";
      sha256 = "55ded6b5ec9ad382494f858d8ab5def0ed6c7d529481cd212863b2edde3b5e07";
    })
  ];

  # We need to unpack the tarball or copy the svg file
  unpackCmd = "tar -xjf $curSrc || (stripHash $curSrc; cp $curSrc ./$strippedName)";

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

  installPhase = ''
    install -dm755 "$out/share/geogebra"
    install "geogebra/"* -t "$out/share/geogebra/"
    mkdir "$out/bin"

    cat <<EOF >"$out/bin/geogebra"
    #! $SHELL
    export GG_PATH="$out/share/geogebra"
    export JAVACMD="${jre}/bin/java"
    exec "\$GG_PATH/geogebra" "\$@"
    EOF

    chmod +x "$out/bin/geogebra"

    mkdir -p $out/share/applications
    cp ${desktopItem}/share/applications/* $out/share/applications/

    install -Dm644 "../geogebra-logo.svg" "$out/share/icons/hicolor/scalable/apps/geogebra.svg"
  '';

  meta = {
    description = "Dynamic mathematics software with graphics, algebra and spreadsheets";
    longDescription = ''
      Dynamic mathematics software for all levels of education that brings
      together geometry, algebra, spreadsheets, graphing, statistics and
      calculus in one easy-to-use package.
    '';
    homepage = https://www.geogebra.org/;
    license = with stdenv.lib.licenses; [gpl3  cc-by-nc-sa-30 geogebra];
    platforms = stdenv.lib.platforms.all;
  };
}
