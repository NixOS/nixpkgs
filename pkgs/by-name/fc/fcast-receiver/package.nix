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

buildNpmPackage rec {
  pname = "fcast-receiver";
  version = "2.0.0";

  src = fetchFromGitLab {
    domain = "gitlab.futo.org";
    owner = "videostreaming";
    repo = "fcast";
    rev = "4af2a537ef431918a5cf53b3ba18abe6b2d18c1e";
    hash = "sha256-Y3IyxYLGRi/fLh5A3ap+5x3Wny9WRplaYtBM3R3I8+U=";
  };

  sourceRoot = "${src.name}/receivers/electron";

  makeCacheWritable = true;

  npmDepsHash = "sha256-GXlqOukGWtt3KP+xsAiDsUG2Naej0v2RL7Vq3hqcavE=";

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
    install -Dm644 assets/icons/app/icon.png $out/share/pixmaps/fcast-receiver.png
    ln -s $out/lib/node_modules/fcast-receiver/package.json $out/lib/node_modules/fcast-receiver/dist/package.json

    makeWrapper ${electron}/bin/electron $out/bin/fcast-receiver \
      --add-flags $out/lib/node_modules/fcast-receiver/dist/bundle.js
  '';

  meta = {
    description = "FCast Receiver, an open-source media streaming receiver";
    longDescription = ''
      FCast Receiver is a receiver for an open-source media streaming protocol, FCast, an alternative to Chromecast and AirPlay.
    '';
    homepage = "https://fcast.org/";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ ymstnt ];
    mainProgram = "fcast-receiver";
    platforms = lib.platforms.linux;
  };
}
