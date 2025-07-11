{
  flutter,
  fetchFromGitHub,
  util-linux,
  wrapGAppsHook3,
  makeDesktopItem,
  lib,
}:

flutter.buildFlutterApplication rec {
  pname = "pathplanner";
  version = "2025.2.2";

  src = fetchFromGitHub {
    owner = "mjansen4857";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-RTLesH7j3R9JbvNr46Tk8bHbCeMm0daeTaxSOibkPjM=";
  };

  nativeBuildInputs = [
    util-linux
  ];

  propagatedBuildInputs = [
    wrapGAppsHook3
  ];

  pubspecLock = lib.importJSON ./pubspec.lock;

  desktop = makeDesktopItem {
    desktopName = "Path Planner";
    name = pname;
    exec = pname;
    icon = pname;
    comment = "FRC motion planner";
    categories = [
      "Utility"
    ];
    genericName = pname;
  };

  postInstall = ''
    mkdir -p $out/share/icons $out/share/applications
    cp $out/app/pathplanner/data/flutter_assets/images/icon.png $out/share/icons/${pname}.png
    cp ${desktop}/share/applications/${pname}.desktop $out/share/applications
  '';

  meta = {
    description = "A motion profile generator for FRC robots";
    homepage = "https://pathplanner.dev/home.html";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ totaltax ];
    platforms = lib.platforms.linux;
  };
}
