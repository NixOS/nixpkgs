{
  stdenv,
  hurrycurry-server,
  godot_4_5,
  ffmpeg,
  writableTmpDirAsHomeHook,
  copyDesktopItems,
  makeDesktopItem,
}:

stdenv.mkDerivation {
  pname = "hurrycurry-client";
  inherit (hurrycurry-server) version src;

  nativeBuildInputs = [
    godot_4_5
    ffmpeg
    writableTmpDirAsHomeHook
    copyDesktopItems
  ];

  postPatch = ''
    patchShebangs --build data/recipes/anticurry.sed
  '';

  buildPhase = ''
    runHook preBuild

    ln -s "${godot_4_5.export-template}" $HOME/.local

    make all_client
    pushd client
      mkdir -p build
      godot4 --headless --export-release "${stdenv.hostPlatform.config}" ./build/hurrycurry
    popd

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 client/build/hurrycurry -t $out/bin
    install -Dm644 client/icons/main.png $out/share/icons/hicolor/1024x1024/apps/hurrycurry.png

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      type = "Application";
      name = "hurrycurry";
      exec = "hurrycurry";
      icon = "hurrycurry";
      terminal = false;
      comment = "Cooperative 3D multiplayer game about cooking";
      desktopName = "Hurry Curry!";
      categories = [ "Game" ];
    })
  ];

  meta = hurrycurry-server.meta // {
    mainProgram = "hurrycurry";
  };
}
