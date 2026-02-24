{
  stdenv,
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  makeDesktopItem,
  copyDesktopItems,
  electron,
  nix-update-script,
}:

buildNpmPackage rec {
  pname = "caprine";
  version = "2.60.3";

  src = fetchFromGitHub {
    owner = "sindresorhus";
    repo = "caprine";
    rev = "v${version}";
    hash = "sha256-yfCilJ62m7nKe8B+4puwAbNgr2g1P7HaKIhFINdv0/k=";
  };

  ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  npmDepsHash = "sha256-hNOAplCSXrO4NZqDTkmhf0oZVeGRUHr2Y/Qdx2RIV9c=";

  nativeBuildInputs = [ copyDesktopItems ];

  postBuild = ''
    cp -r ${electron.dist} electron-dist
    chmod -R u+w electron-dist

    npm exec electron-builder -- \
        --dir \
        -c.npmRebuild=true \
        -c.asarUnpack="**/*.node" \
        -c.electronDist=electron-dist \
        -c.electronVersion=${electron.version}
  '';

  patches = [ ./001-disable-auto-update.patch ];

  installPhase = ''
    runHook preInstall

    ${lib.optionalString stdenv.hostPlatform.isLinux ''
      mkdir -p $out/share/caprine
      cp -r dist/*-unpacked/{locales,resources{,.pak}} $out/share/caprine

      makeWrapper ${lib.getExe electron} $out/bin/caprine \
          --add-flags $out/share/caprine/resources/app.asar \
          --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
          --set-default ELECTRON_IS_DEV 0 \
          --inherit-argv0

      install -Dm644 build/icon.png $out/share/icons/hicolor/512x512/apps/caprine.png
    ''}

    ${lib.optionalString stdenv.hostPlatform.isDarwin ''
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

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/sindresorhus/caprine/releases/tag/${src.rev}";
    description = "Elegant Facebook Messenger desktop app";
    homepage = "https://github.com/sindresorhus/caprine";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      khaneliman
    ];
    inherit (electron.meta) platforms;
  };
}
