{
  flutter327,
  fetchFromGitHub,
  util-linux,
  copyDesktopItems,
  makeDesktopItem,
  lib,
}:

flutter327.buildFlutterApplication rec {
  pname = "pathplanner";
  version = "2025.2.2";

  src = fetchFromGitHub {
    owner = "mjansen4857";
    repo = "pathplanner";
    tag = "v${version}";
    hash = "sha256-RTLesH7j3R9JbvNr46Tk8bHbCeMm0daeTaxSOibkPjM=";
  };

  nativeBuildInputs = [
    util-linux
    copyDesktopItems
  ];

  pubspecLock = lib.importJSON ./pubspec.lock;

  desktopItems = [
    (makeDesktopItem {
      desktopName = "Path Planner";
      name = "pathplanner";
      exec = "pathplanner";
      icon = "pathplanner";
      comment = "FRC motion planner";
      categories = [
        "Utility"
      ];
      genericName = "pathplanner";
    })
  ];

  postPatch = ''
    substituteInPlace linux/my_application.cc \
      --replace-fail "images/icon.ico" "$out/app/pathplanner/data/flutter_assets/images/icon.ico"
  '';

  postInstall = ''
    install -Dm0644 $out/app/pathplanner/data/flutter_assets/images/icon.png $out/share/icons/pathplanner.png
  '';

  meta = {
    description = "Motion profile generator for FRC robots";
    homepage = "https://pathplanner.dev/home.html";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ totaltax ];
    platforms = lib.platforms.linux;
  };
}
