{ lib, stdenv, fetchurl, makeDesktopItem, makeWrapper, unzip, mono }:

let
  pname = "mission-planner";
  desktopItem = makeDesktopItem {
    name = pname;
    exec = pname;
    icon = pname;
    comment = "MissionPlanner GCS & Ardupilot configuration tool";
    desktopName = "MissionPlanner";
    genericName = "Ground Control Station";
  };
in stdenv.mkDerivation rec {
  inherit pname;
  version = "1.3.80";

  src = fetchurl {
    url = "https://firmware.ardupilot.org/Tools/MissionPlanner/MissionPlanner-${version}.zip";
    sha256 = "sha256-iivlaQWtOMJHchmR92FoqTaosGJ9F1AgFtuFgDE/9qQ=";
  };

  nativeBuildInputs = [ makeWrapper mono unzip ];
  sourceRoot = ".";

  AOT_FILES = [ "MissionPlanner.exe" "MissionPlanner.*.dll" ];

  buildPhase = ''
    runHook preBuild
    for file in $AOT_FILES
    do
      mono --aot $file
    done
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{bin,opt/mission-planner}
    install -m 444 -D mpdesktop150.png $out/share/icons/mission-planner.png
    cp -r ${desktopItem}/share/applications $out/share/
    mv * $out/opt/mission-planner
    makeWrapper ${mono}/bin/mono $out/bin/mission-planner \
      --add-flags $out/opt/mission-planner/MissionPlanner.exe
    runHook postInstall
  '';

  meta = with lib; {
    description = "ArduPilot ground station";
    mainProgram = "mission-planner";
    longDescription = ''
      Full-featured ground station application for the ArduPilot open source
      autopilot project.  Lets you both flash, configure and control ArduPilot
      Plane, Copter and Rover targets.
    '';
    homepage = "https://ardupilot.org/planner/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ wucke13 ];
    platforms = platforms.all;
  };
}
