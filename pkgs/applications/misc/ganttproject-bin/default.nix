{ lib, stdenv, fetchzip, makeDesktopItem, makeWrapper
, jre
}:

stdenv.mkDerivation rec {
  pname = "ganttproject-bin";
  version = "3.3.3300";

  src = fetchzip {
    url = "https://dl.ganttproject.biz/ganttproject-${version}/ganttproject-${version}.zip";
    stripRoot = false;
    hash = "sha256-U9x64UIBuVtW44zbsdWuMRZyEJhZ8VUWbDVtapTGPMo=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ jre ];

  installPhase = let

    desktopItem = makeDesktopItem {
      name = "ganttproject";
      exec = "ganttproject";
      icon = "ganttproject";
      desktopName = "GanttProject";
      genericName = "Shedule and manage projects";
      comment = meta.description;
      categories = [ "Office" ];
    };

    javaOptions = [
      "-Dawt.useSystemAAFontSettings=on"
    ];

  in ''
    mkdir -pv "$out/share/ganttproject"
    cp -rv *  "$out/share/ganttproject"

    mkdir -pv "$out/bin"
    wrapProgram "$out/share/ganttproject/ganttproject" \
      --set JAVA_HOME "${jre}" \
      --set _JAVA_OPTIONS "${builtins.toString javaOptions}"

    mv -v "$out/share/ganttproject/ganttproject" "$out/bin"

    cp -rv "${desktopItem}/share/applications" "$out/share"
  '';

  meta = with lib; {
    description = "Project scheduling and management";
    homepage = "https://www.ganttproject.biz/";
    downloadPage = "https://www.ganttproject.biz/download";
    # GanttProject itself is GPL3+. All bundled libraries are declared
    # ‘GPL3-compatible’. See ${downloadPage} for detailed information.
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.vidbina ];
  };
}
