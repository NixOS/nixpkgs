{ fetchurl, stdenv, makeDesktopItem, makeWrapper, unzip, jdk11 }:

stdenv.mkDerivation rec {
  pname = "gpsprune";
  version = "20";

  src = fetchurl {
    url = "https://activityworkshop.net/software/gpsprune/gpsprune_${version}.jar";
    sha256 = "1i9p6h98azgradrrkcwx18zwz4c6zkxp4bfykpa2imi1z3ry5q2b";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ jdk11 ];

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
    makeWrapper ${jdk11}/bin/java $out/bin/gpsprune \
      --add-flags "-jar $out/share/java/gpsprune.jar"
    mkdir -p $out/share/applications
    cp $desktopItem/share/applications"/"* $out/share/applications
    mkdir -p $out/share/pixmaps
    ${unzip}/bin/unzip -p $src tim/prune/gui/images/window_icon_64.png > $out/share/pixmaps/gpsprune.png
  '';

  meta = with stdenv.lib; {
    description = "Application for viewing, editing and converting GPS coordinate data";
    homepage = "https://activityworkshop.net/software/gpsprune/";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.rycee ];
    platforms = platforms.all;
  };
}
