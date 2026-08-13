{
  lib,
  stdenv,
  fetchzip,
  makeDesktopItem,
  makeWrapper,
  openjdk17,
}:
let
  jre = openjdk17.override {
    enableJavaFX = true;
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "ganttproject-bin";
  version = "3.3.3316";

  src = fetchzip {
    url = "https://dl.ganttproject.biz/ganttproject-${finalAttrs.version}/ganttproject-${finalAttrs.version}.zip";
    stripRoot = false;
    hash = "sha256-tiEq/xdC0gXiUInLS9xGR/vI/BpdSA+mSf5yukuejc4=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ jre ];

  installPhase =
    let

      desktopItem = makeDesktopItem {
        name = "ganttproject";
        exec = "ganttproject";
        icon = "ganttproject";
        desktopName = "GanttProject";
        genericName = "Shedule and manage projects";
        comment = finalAttrs.meta.description;
        categories = [ "Office" ];
      };

      javaOptions = [
        "-Dawt.useSystemAAFontSettings=gasp"
      ];

    in
    ''
      mkdir -pv "$out/share/ganttproject"
      cp -rv *  "$out/share/ganttproject"

      mkdir -pv "$out/bin"
      wrapProgram "$out/share/ganttproject/ganttproject" \
        --set JAVA_HOME "${jre}" \
        --prefix _JAVA_OPTIONS " " "${toString javaOptions}"

      mv -v "$out/share/ganttproject/ganttproject" "$out/bin"

      cp -rv "${desktopItem}/share/applications" "$out/share"
    '';

  meta = {
    description = "Project scheduling and management";
    homepage = "https://www.ganttproject.biz/";
    downloadPage = "https://www.ganttproject.biz/download";
    # GanttProject itself is GPL3+. All bundled libraries are declared
    # ‘GPL3-compatible’. See ${downloadPage} for detailed information.
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "ganttproject";
  };
})
