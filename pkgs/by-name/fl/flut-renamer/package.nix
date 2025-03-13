{
  lib,
  fetchFromGitHub,
  flutter324,
}:

flutter324.buildFlutterApplication rec {
  pname = "flut-renamer";
  version = "1.5.4";

  src = fetchFromGitHub {
    owner = "sun-jiao";
    repo = "flut-renamer";
    tag = version;
    hash = "sha256-maPmZwsmmjyvHgutWF+8CIw2NA6HCB4/PPiiCAG+n8I=";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  postInstall = ''
    install -Dm644 assets/desktop.png $out/share/pixmaps/flut-renamer.png
    install -Dm644 appimage/flut-renamer.desktop $out/share/applications/flut-renamer.desktop
    substituteInPlace $out/share/applications/flut-renamer.desktop \
      --replace-fail "Icon=desktop" "Icon=flut-renamer"
  '';

  meta = {
    description = "Bulk file renamer written in flutter";
    homepage = "https://github.com/sun-jiao/flut-renamer";
    mainProgram = "flut-renamer";
    platforms = lib.platforms.linux;
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ nayeko ];
  };
}
