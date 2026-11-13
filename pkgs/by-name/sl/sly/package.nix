{
  lib,
  fetchFromCodeberg,
  flutter347,
  runCommand,
  yq-go,
  _experimental-update-script-combinators,
  nix-update-script,
}:

flutter347.buildFlutterApplication (finalAttrs: {
  pname = "sly";
  version = "1.1.2";

  src = fetchFromCodeberg {
    owner = "Sly";
    repo = "Sly";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jOC8mZdBRC7T/eEgPXlUAC44IcknlUk+TWNDdR0m4Ng=";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  postInstall = ''
    install -Dm0644 linux/page.kramo.Sly.desktop $out/share/applications/page.kramo.Sly.desktop
    install -Dm0644 linux/flatpak/page.kramo.Sly.svg $out/share/icons/hicolor/scalable/apps/page.kramo.Sly.svg
    install -Dm0644 linux/flatpak/page.kramo.Sly-symbolic.svg $out/share/icons/hicolor/symbolic/apps/page.kramo.Sly-symbolic.svg
  '';

  passthru = {
    pubspecSource =
      runCommand "pubspec.lock.json"
        {
          inherit (finalAttrs) src;
          nativeBuildInputs = [ yq-go ];
        }
        ''
          yq eval --output-format=json --prettyPrint $src/pubspec.lock > "$out"
        '';
    updateScript = _experimental-update-script-combinators.sequence [
      (nix-update-script { })
      (
        (_experimental-update-script-combinators.copyAttrOutputToFile "sly.pubspecSource" ./pubspec.lock.json)
        // {
          supportedFeatures = [ ];
        }
      )
    ];
  };

  meta = {
    description = "Friendly image editor";
    homepage = "https://codeberg.org/Sly/Sly";
    changelog = "https://codeberg.org/Sly/Sly/releases/tag/v${finalAttrs.version}";
    mainProgram = "sly";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
