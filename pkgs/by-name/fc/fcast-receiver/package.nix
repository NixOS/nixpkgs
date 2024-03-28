{ lib
, buildNpmPackage
, fetchFromGitLab
, makeDesktopItem
, copyDesktopItems
, makeWrapper
, electron
}:

buildNpmPackage rec {
  pname = "fcast-receiver";
  version = "1.0.12";

  src = fetchFromGitLab {
    domain = "gitlab.futo.org";
    owner = "videostreaming";
    repo = "fcast";
    rev = "b13d0f7e8150c279d377a78f89d338b7fc0f5539";
    hash = "sha256-NqOQFEP5MWFNWHj6ZpNCVh8D/4YlNhqA/Db6hdAXepo=";
  };

  sourceRoot = "${src.name}/receivers/electron";

  makeCacheWritable = true;
  dontPatchELF = true;

  npmDepsHash = "sha256-gpbFZ8rKYR/GUY1l4eH5io/lz6FpJLUTl5h8q3haxvw=";

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      desktopName = "FCast Receiver";
      genericName = "Media Streaming Receiver";
      exec = "fcast-receiver";
      icon = "fcast-receiver";
      comment = meta.description;
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
