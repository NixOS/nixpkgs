{ stdenv, fetchzip, makeDesktopItem, makeWrapper
, jre }:

stdenv.mkDerivation rec {
  name = "ganttproject-bin-${version}";
  version = "2.7.2";

  src = let build = "r1954"; in fetchzip {
    sha256 = "0l655w6n88j7klz56af8xkpiv1pwlkfl5x1d33sqv9dnyisyw2hc";
    url = "https://dl.ganttproject.biz/ganttproject-${version}/"
        + "ganttproject-${version}-${build}.zip";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ jre ];

  phases = [ "unpackPhase" "installPhase" "fixupPhase" ];

  installPhase = let

    desktopItem = makeDesktopItem {
      name = "ganttproject";
      exec = "ganttproject";
      icon = "ganttproject";
      desktopName = "GanttProject";
      genericName = "Shedule and manage projects";
      comment = meta.description;
      categories = "Office;Application;";
    };

  in ''
    mkdir -pv "$out/share/ganttproject"
    cp -rv *  "$out/share/ganttproject"

    mkdir -pv "$out/bin"
    wrapProgram "$out/share/ganttproject/ganttproject" \
      --set JAVA_HOME "${jre}"
    mv -v "$out/share/ganttproject/ganttproject" "$out/bin"

    install -v -Dm644 \
      plugins/net.sourceforge.ganttproject/data/resources/icons/ganttproject.png \
      "$out/share/pixmaps/ganttproject.png"
    cp -rv "${desktopItem}/share/applications" "$out/share"
  '';

  meta = with stdenv.lib; {
    description = "Project scheduling and management";
    homepage = https://www.ganttproject.biz/;
    downloadPage = https://www.ganttproject.biz/download;
    # GanttProject itself is GPL3+. All bundled libraries are declared
    # ‘GPL3-compatible’. See ${downloadPage} for detailed information.
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ nckx ];
  };
}
