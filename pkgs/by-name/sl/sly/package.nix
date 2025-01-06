{
  lib,
  fetchFromGitHub,
  flutter327,
}:
flutter327.buildFlutterApplication rec {
  pname = "sly";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "kra-mo";
    repo = "Sly";
    tag = "v${version}";
    hash = "sha256-pFTP+oDY3pCSgO26ZtqUR+puMJSFZAEdbM2AqmfkNX8=";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  postInstall = ''
    install -Dm0644 ./packaging/linux/page.kramo.Sly.svg $out/share/icons/hicolor/scalable/apps/page.kramo.Sly.svg
    install -Dm0644 ./packaging/linux/page.kramo.Sly.desktop $out/share/applications/sly.desktop
  '';

  meta = {
    description = "Friendly image editor";
    homepage = "https://github.com/kra-mo/Sly";
    mainProgram = "sly";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ aucub ];
    platforms = lib.platforms.linux;
  };
}
