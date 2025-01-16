{
  lib,
  fetchFromGitHub,
  flutter,
}:
let
  version = "0.4.0";
  src = fetchFromGitHub {
    owner = "kra-mo";
    repo = "sly";
    rev = "v${version}";
    hash = "sha256-P7LhhXQQDRsDQ8bZgfvWazLRMYVGhFhMTD41fgs718g=";
  };
in
flutter.buildFlutterApplication {
  pname = "sly";
  inherit version src;

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  postInstall = ''
    install -Dm0644 ./packaging/linux/page.kramo.Sly.svg $out/share/icons/hicolor/scalable/apps/page.kramo.Sly.svg
    install -Dm0644 ./packaging/linux/page.kramo.Sly.desktop $out/share/applications/page.kramo.Sly.desktop
  '';

  meta = {
    description = "Friendly image editor";
    homepage = "https://github.com/kra-mo/sly";
    mainProgram = "sly";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ aucub ];
    platforms = lib.platforms.linux;
  };
}
