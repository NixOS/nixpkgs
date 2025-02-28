{
  flutter335,
  fetchFromGitHub,
  util-linux,
  xz,
  copyDesktopItems,
  makeDesktopItem,
  lib,
}:

flutter335.buildFlutterApplication rec {
  pname = "pathplanner";
  version = "2026.1.2";

  src = fetchFromGitHub {
    owner = "mjansen4857";
    repo = "pathplanner";
    tag = "v${version}";
    hash = "sha256-ocqBviTfMxjdJdEu++yqUY9JTLs1qEnP94w6HCFp5f0=";
  };

  nativeBuildInputs = [
    util-linux
    xz
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
