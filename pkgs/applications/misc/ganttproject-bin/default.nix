{ lib
, stdenv
, fetchzip
, makeDesktopItem
, makeWrapper
, openjdk11
}:

stdenv.mkDerivation rec {
  pname = "ganttproject-bin";
  version = "3.1.3100";

  src = fetchzip {
    sha256 = "sha256-hw2paak0P670/kemiuqYHIaN0uUtkVKy+AX2X7OdnJ4=";
    url = "https://dl.ganttproject.biz/ganttproject-${version}/ganttproject-${version}.zip";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ openjdk11 ];

  installPhase = let

    desktopItem = makeDesktopItem {
      name = "ganttproject";
      exec = "ganttproject";
      icon = "ganttproject";
      desktopName = "GanttProject";
      genericName = "Shedule and manage projects";
      comment = meta.description;
      categories = "Office;";
    };

    javaOptions = [ "-Dawt.useSystemAAFontSettings=on" ];

  in ''
    mkdir -pv "$out/share/ganttproject"
    cp -rv *  "$out/share/ganttproject"

    mkdir -pv "$out/bin"
    wrapProgram "$out/share/ganttproject/ganttproject" \
      --set JAVA_HOME "${openjdk11}" \
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
