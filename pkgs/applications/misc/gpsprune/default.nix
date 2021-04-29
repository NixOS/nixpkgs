{ fetchurl, lib, stdenv, makeDesktopItem, makeWrapper, unzip, jdk }:

stdenv.mkDerivation rec {
  pname = "gpsprune";
  version = "20.3";

  src = fetchurl {
    url = "https://activityworkshop.net/software/gpsprune/gpsprune_${version}.jar";
    sha256 = "sha256-hmAksLPQxzB4O+ET+O/pmL/J4FG4+Dt0ulSsgjBWKxw=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ jdk ];

  desktopItem = makeDesktopItem {
    name = "gpsprune";
    exec = "gpsprune";
    icon = "gpsprune";
    desktopName = "GpsPrune";
    genericName = "GPS Data Editor";
    comment = meta.description;
    categories = "Education;Geoscience;";
  };

  buildCommand = ''
    mkdir -p $out/bin $out/share/java
    cp -v $src $out/share/java/gpsprune.jar
    makeWrapper ${jdk}/bin/java $out/bin/gpsprune \
      --add-flags "-jar $out/share/java/gpsprune.jar"
    mkdir -p $out/share/applications
    cp $desktopItem/share/applications"/"* $out/share/applications
    mkdir -p $out/share/pixmaps
    ${unzip}/bin/unzip -p $src tim/prune/gui/images/window_icon_64.png > $out/share/pixmaps/gpsprune.png
  '';

  meta = with lib; {
    description = "Application for viewing, editing and converting GPS coordinate data";
    homepage = "https://activityworkshop.net/software/gpsprune/";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.rycee ];
    platforms = platforms.all;
  };
}
