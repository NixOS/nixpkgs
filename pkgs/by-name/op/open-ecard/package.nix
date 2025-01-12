{
  lib,
  stdenv,
  fetchurl,
  jre,
  pcsclite,
  makeDesktopItem,
  makeWrapper,
}:

let
  version = "1.2.4";
  srcs = {
    richclient = fetchurl {
      url = "https://jnlp.openecard.org/richclient-${version}-20171212-0958.jar";
      sha256 = "1ckhyhszp4zhfb5mn67lz603b55z814jh0sz0q5hriqzx017j7nr";
    };
    cifs = fetchurl {
      url = "https://jnlp.openecard.org/cifs-${version}-20171212-0958.jar";
      sha256 = "0rc862lx3y6sw87r1v5xjmqqpysyr1x6yqhycqmcdrwz0j3wykrr";
    };
    logo = fetchurl {
      url = "https://raw.githubusercontent.com/ecsec/open-ecard/1.2.3/gui/graphics/src/main/ext/oec_logo_bg-transparent.svg";
      sha256 = "0rpmyv10vjx2yfpm03mqliygcww8af2wnrnrppmsazdplksaxkhs";
    };
  };
in
stdenv.mkDerivation rec {
  pname = "open-ecard";
  inherit version;

  src = srcs.richclient;

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  desktopItem = makeDesktopItem {
    name = pname;
    desktopName = "Open eCard App";
    genericName = "eCard App";
    comment = "Client side implementation of the eCard-API-Framework";
    icon = "oec_logo_bg-transparent.svg";
    exec = pname;
    categories = [
      "Utility"
      "Security"
    ];
  };

  installPhase = ''
    mkdir -p $out/share/java
    cp ${srcs.richclient} $out/share/java/richclient-${version}.jar
    cp ${srcs.cifs} $out/share/java/cifs-${version}.jar

    mkdir -p $out/share/applications $out/share/pixmaps
    cp $desktopItem/share/applications/* $out/share/applications
    cp ${srcs.logo} $out/share/pixmaps/oec_logo_bg-transparent.svg

    mkdir -p $out/bin
    makeWrapper ${jre}/bin/java $out/bin/${pname} \
      --add-flags "-cp $out/share/java/cifs-${version}.jar" \
      --add-flags "-jar $out/share/java/richclient-${version}.jar" \
      --suffix LD_LIBRARY_PATH ':' ${lib.getLib pcsclite}/lib
  '';

  meta = with lib; {
    description = "Client side implementation of the eCard-API-Framework (BSI
      TR-03112) and related international standards, such as ISO/IEC 24727";
    mainProgram = "open-ecard";
    homepage = "https://www.openecard.org/";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.gpl3;
    maintainers = with maintainers; [ sephalon ];
    platforms = platforms.linux;
  };
}
