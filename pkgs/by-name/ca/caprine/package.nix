{
  stdenv,
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  makeDesktopItem,
  copyDesktopItems,
  electron,
}:

let
  electronDist = electron + (if stdenv.isDarwin then "/Applications" else "/libexec/electron");
in
buildNpmPackage rec {
  pname = "caprine";
  version = "2.60.1";

  src = fetchFromGitHub {
    owner = "sindresorhus";
    repo = "caprine";
    rev = "v${version}";
    hash = "sha256-y4W295i7FhgJC3SlwSr801fLOGJY1WF136bbkkBUvyw=";
  };

  ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  npmDepsHash = "sha256-JHaUc2p+wHsqWtls8xquHK9qnypuCrR0AQMGxcrTsC0=";

  nativeBuildInputs = [ copyDesktopItems ];

  postBuild = ''
    cp -r ${electronDist} electron-dist
    chmod -R u+w electron-dist

    npm exec electron-builder -- \
        --dir \
        -c.npmRebuild=true \
        -c.asarUnpack="**/*.node" \
        -c.electronDist=electron-dist \
        -c.electronVersion=${electron.version}
  '';

  installPhase = ''
    runHook preInstall

    ${lib.optionalString stdenv.isLinux ''
      mkdir -p $out/share/caprine
      cp -r dist/*-unpacked/{locales,resources{,.pak}} $out/share/caprine

      makeWrapper ${lib.getExe electron} $out/bin/caprine \
          --add-flags $out/share/caprine/resources/app.asar \
          --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
          --set-default ELECTRON_IS_DEV 0 \
          --inherit-argv0

      install -Dm644 build/icon.png $out/share/icons/hicolor/512x512/apps/caprine.png
    ''}

    ${lib.optionalString stdenv.isDarwin ''
      mkdir -p $out/Applications
      cp -r dist/mac*/"Caprine.app" $out/Applications
      makeWrapper "$out/Applications/Caprine.app/Contents/MacOS/Caprine" $out/bin/caprine
    ''}

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "caprine";
      exec = "caprine %U";
      icon = "caprine";
      desktopName = "Caprine";
      comment = meta.description;
      categories = [
        "Network"
        "InstantMessaging"
        "Chat"
      ];
      mimeTypes = [ "x-scheme-handler/caprine" ];
      terminal = false;
    })
  ];

  meta = {
    changelog = "https://github.com/sindresorhus/caprine/releases/tag/${src.rev}";
    description = "Elegant Facebook Messenger desktop app";
    homepage = "https://github.com/sindresorhus/caprine";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ astronaut0212 ];
    inherit (electron.meta) platforms;
  };
}
