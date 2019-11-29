{ fetchurl, stdenv, makeDesktopItem, makeWrapper, unzip, jre8 }:

stdenv.mkDerivation rec {
  pname = "gpsprune";
  version = "19.2";

  src = fetchurl {
    url = "https://activityworkshop.net/software/gpsprune/gpsprune_${version}.jar";
    sha256 = "1q2kpkkh75b9l1x7fkmv88s8k84gzcdnrg5sgf8ih0zrp49lawg9";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ jre8 ];

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
    makeWrapper ${jre8}/bin/java $out/bin/gpsprune \
      --add-flags "-jar $out/share/java/gpsprune.jar"
    mkdir -p $out/share/applications
    cp $desktopItem/share/applications"/"* $out/share/applications
    mkdir -p $out/share/pixmaps
    ${unzip}/bin/unzip -p $src tim/prune/gui/images/window_icon_64.png > $out/share/pixmaps/gpsprune.png
  '';

  meta = with stdenv.lib; {
    description = "Application for viewing, editing and converting GPS coordinate data";
    homepage = https://activityworkshop.net/software/gpsprune/;
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.rycee ];
    platforms = platforms.all;
  };
}
