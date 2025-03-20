{
  lib,
  buildNpmPackage,
  fetchFromGitLab,
  makeDesktopItem,
  copyDesktopItems,
  makeWrapper,
  electron,
}:

buildNpmPackage rec {
  pname = "fcast-receiver";
  version = "1.0.14";

  src = fetchFromGitLab {
    domain = "gitlab.futo.org";
    owner = "videostreaming";
    repo = "fcast";
    rev = "c7a1cb27c470870df50dbf0de00a133061298d46";
    hash = "sha256-9xF1DZ2wt6zMoUQywmvnNN3Z8m4GhOFJElENhozF9c8=";
  };

  sourceRoot = "${src.name}/receivers/electron";

  makeCacheWritable = true;

  npmDepsHash = "sha256-gpbFZ8rKYR/GUY1l4eH5io/lz6FpJLUTl5h8q3haxvw=";

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  desktopItems = [
    (makeDesktopItem {
      name = pname;
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
  ];

  postInstall = ''
    install -Dm644 $out/lib/node_modules/fcast-receiver/app.png $out/share/pixmaps/fcast-receiver.png

    makeWrapper ${electron}/bin/electron $out/bin/fcast-receiver \
      --add-flags $out/lib/node_modules/fcast-receiver/dist/bundle.js
  '';

  meta = with lib; {
    description = "FCast Receiver, an open-source media streaming receiver";
    longDescription = ''
      FCast Receiver is a receiver for an open-source media streaming protocol, FCast, an alternative to Chromecast and AirPlay.
    '';
    homepage = "https://fcast.org/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ ymstnt ];
    mainProgram = "fcast-receiver";
    platforms = platforms.linux;
  };
}
