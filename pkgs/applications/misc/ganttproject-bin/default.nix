{ stdenv, lib, fetchzip, makeDesktopItem, makeWrapper
, jre
}:

stdenv.mkDerivation rec {
  name = "ganttproject-bin-${version}";
  version = "2.8.9";

  src = let build = "r2335"; in fetchzip {
    sha256 = "1fmfrsy9z2nff0bxwj7xsfbwkb9y1dmssvy5wkmf9ngihyzj3w1k";
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

  meta = with stdenv.lib; {
    description = "Project scheduling and management";
    homepage = https://www.ganttproject.biz/;
    downloadPage = https://www.ganttproject.biz/download;
    # GanttProject itself is GPL3+. All bundled libraries are declared
    # ‘GPL3-compatible’. See ${downloadPage} for detailed information.
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.vidbina ];
  };
}
