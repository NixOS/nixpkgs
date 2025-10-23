{
  lib,
  fetchFromGitHub,
  flutter327,
  runCommand,
  yq,
  sly,
  _experimental-update-script-combinators,
  gitUpdater,
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
    install -Dm0644 packaging/linux/page.kramo.Sly.svg $out/share/icons/hicolor/scalable/apps/page.kramo.Sly.svg
    install -Dm0644 packaging/linux/page.kramo.Sly.desktop $out/share/applications/sly.desktop
  '';

  passthru = {
    pubspecSource =
      runCommand "pubspec.lock.json"
        {
          nativeBuildInputs = [ yq ];
          inherit (sly) src;
        }
        ''
          cat $src/pubspec.lock | yq > $out
        '';
    updateScript = _experimental-update-script-combinators.sequence [
      (gitUpdater { rev-prefix = "v"; })
      (_experimental-update-script-combinators.copyAttrOutputToFile "sly.pubspecSource" ./pubspec.lock.json)
    ];
  };

  meta = {
    description = "Friendly image editor";
    homepage = "https://github.com/kra-mo/Sly";
    mainProgram = "sly";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
}
