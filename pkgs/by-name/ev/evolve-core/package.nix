{
  lib,
  fetchFromGitHub,
  flutter329,
  makeDesktopItem,
  copyDesktopItems,
}:

flutter329.buildFlutterApplication rec {
  pname = "evolve-core";
  version = "1.7";

  src = fetchFromGitHub {
    owner = "arcnations-united";
    repo = "evolve-core";
    tag = "v${version}";
    hash = "sha256-U5qMJ3aquD2EzWXwTKw0GJPdaCmK68v8DLdJMAwKrzs=";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  desktopItems = [
    (makeDesktopItem {
      name = "Evolve Core";
      exec = "evolvecore";
      icon = "evolvecore";
      desktopName = "evolvecore";
      genericName = "A modern GTK theme manager";
      categories = [ "Utility" ];
      comment = "A modern GTK Theme Manager for GNOME with GTK 4.0 support and some cool features";
      terminal = false;
      type = "Application";
      startupWMClass = "evolvecore";
    })
  ];

  nativeBuildInputs = [
    copyDesktopItems
  ];

  postInstall = ''
    install -D assets/iconfile.png -t $out/share/icons
    mv $out/share/icons/iconfile.png $out/share/icons/evolvecore.png
  '';

  meta = {
    description = "Modern GTK Theme Manager for GNOME with GTK 4.0 support and some cool features";
    homepage = "https://github.com/arcnations-united/evolve-core";
    changelog = "https://github.com/arcnations-united/evolve-core/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ genga898 ];
    mainProgram = "evolvecore";
    platforms = lib.platforms.linux;
  };

}
