{ fetchurl, stdenv, makeDesktopItem, unzip, bash, jre8 }:

stdenv.mkDerivation rec {
  name = "gpsprune-${version}";
  version = "18.4";

  src = fetchurl {
    url = "http://activityworkshop.net/software/gpsprune/gpsprune_${version}.jar";
    sha256 = "0wrkvff3c1w66373m2w2ib07rkn3rmbp3n7ixz72qd1swvbk6xx1";
  };

  phases = [ "installPhase" ];

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

  installPhase = ''
    mkdir -p $out/bin $out/share/java
    cp -v $src $out/share/java/gpsprune.jar
    cat > $out/bin/gpsprune <<EOF
    #!${bash}/bin/bash
    exec ${jre8}/bin/java -jar $out/share/java/gpsprune.jar "\$@"
    EOF
    chmod 755 $out/bin/gpsprune

    mkdir -p $out/share/applications
    cp $desktopItem/share/applications"/"* $out/share/applications
    mkdir -p $out/share/pixmaps
    ${unzip}/bin/unzip -p $src tim/prune/gui/images/window_icon_64.png > $out/share/pixmaps/gpsprune.png
  '';

  meta = with stdenv.lib; {
    description = "Application for viewing, editing and converting GPS coordinate data";
    homepage = http://activityworkshop.net/software/gpsprune/;
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.rycee ];
    platforms = platforms.all;
  };
}
