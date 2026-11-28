{
  lib,
  buildNpmPackage,
  fetchFromGitLab,
  makeDesktopItem,
  copyDesktopItems,
  makeWrapper,
  electron,
  rsync,
}:

buildNpmPackage (finalAttrs: {
  pname = "fcast-receiver";
  version = "2.2.4";

  src = fetchFromGitLab {
    domain = "gitlab.futo.org";
    owner = "videostreaming";
    repo = "fcast";
    tag = "electron-v${finalAttrs.version}";
    hash = "sha256-pbptK8LvdN2b/3SpRyTXKmMX9bN4mOmOiUsys67Syew=";
  };

  sourceRoot = "${finalAttrs.src.name}/receivers/electron";

  makeCacheWritable = true;

  npmDepsHash = "sha256-H05I4gDCZq+pkmynEg88Na7oxuK04G284+G7G1J7HVM=";

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  desktopItems = [
    (makeDesktopItem {
      name = "fcast-receiver";
      desktopName = "FCast Receiver";
      genericName = "Media Streaming Receiver";
      exec = "fcast-receiver";
      icon = "fcast-receiver";
      comment = "FCast Receiver, an open-source media streaming receiver";
    })
  ];

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
    rsync
  ];

  postInstall = ''
    install -Dm644 assets/icons/app/icon.png $out/share/icons/hicolor/512x512/apps/fcast-receiver.png
    ln -s $out/lib/node_modules/fcast-receiver/package.json $out/lib/node_modules/fcast-receiver/dist/package.json

    makeWrapper ${electron}/bin/electron $out/bin/fcast-receiver \
      --add-flags $out/lib/node_modules/fcast-receiver/dist/bundle.js
  '';

  meta = {
    description = "Open-source media streaming receiver";
    longDescription = ''
      FCast Receiver is a receiver for an open-source media streaming protocol, FCast, an alternative to Chromecast and AirPlay.
    '';
    homepage = "https://fcast.org/";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ ymstnt ];
    mainProgram = "fcast-receiver";
    platforms = lib.platforms.linux;
  };
})
