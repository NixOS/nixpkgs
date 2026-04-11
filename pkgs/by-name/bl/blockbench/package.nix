{
  lib,
  stdenv,
  buildNpmPackage,
  fetchFromGitHub,
  makeWrapper,
  imagemagick,
  copyDesktopItems,
  makeDesktopItem,
  electron,
}:

buildNpmPackage rec {
  pname = "blockbench";
  version = "5.1.2";

  src = fetchFromGitHub {
    owner = "JannisX11";
    repo = "blockbench";
    tag = "v${version}";
    hash = "sha256-fU38Exv83cKaPFA26zmwYZlkscCbAEz/7Gch5j/qHjk=";
  };

  patches = [
    # On linux we're running Blockbench by giving the path to the app.asar file to the electron executable,
    # but Blockbench assumes paths at the and og the argv are files to be opened
    # This patch disables trying to open the app.asar file
    ./dont-assume-opening-app-asar.patch
  ];

  nativeBuildInputs = [
    makeWrapper
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    imagemagick # for icon resizing
    copyDesktopItems
  ];

  npmDepsHash = "sha256-0FdPTyoVNrsx0LJYcpfZPKZwUKzyJaU6XNnm2bY9F/s=";
  makeCacheWritable = true;

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = 1;

  # disable notarization logic
  postConfigure = lib.optionalString stdenv.hostPlatform.isDarwin ''
    sed -i "/afterSign/d" package.json
  '';

  npmBuildScript = "build-electron";

  postBuild = ''
    # electronDist needs to be modifiable on Darwin
    cp -r ${electron.dist} electron-dist
    chmod -R u+w electron-dist

    npm exec electron-builder -- \
      --dir \
      -c.electronDist=electron-dist \
      -c.electronVersion=${electron.version} \
      -c.mac.identity=null
  '';

  installPhase = ''
    runHook preInstall
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/Applications
    cp -r dist-electron/mac*/Blockbench.app $out/Applications
    makeWrapper $out/Applications/Blockbench.app/Contents/MacOS/Blockbench $out/bin/blockbench
  ''
  + lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    mkdir -p $out/share/blockbench
    cp -r dist-electron/*-unpacked/{locales,resources{,.pak}} $out/share/blockbench

    for size in 16 32 48 64 128 256 512; do
      mkdir -p $out/share/icons/hicolor/"$size"x"$size"/apps
      magick icon.png -resize "$size"x"$size" $out/share/icons/hicolor/"$size"x"$size"/apps/blockbench.png
    done

    makeWrapper ${lib.getExe electron} $out/bin/blockbench \
      --add-flags $out/share/blockbench/resources/app.asar \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
      --inherit-argv0
  ''
  + ''
    runHook postInstall
  '';

  # based on desktop file found in the published AppImage archive
  desktopItems = [
    (makeDesktopItem {
      name = "blockbench";
      exec = "blockbench %U";
      icon = "blockbench";
      desktopName = "Blockbench";
      comment = meta.description;
      categories = [ "3DGraphics" ];
      startupWMClass = "Blockbench";
      terminal = false;
    })
  ];

  meta = {
    changelog = "https://github.com/JannisX11/blockbench/releases/tag/v${version}";
    description = "Low-poly 3D modeling and animation software";
    homepage = "https://blockbench.net/";
    license = lib.licenses.gpl3Only;
    mainProgram = "blockbench";
    maintainers = with lib.maintainers; [ tomasajt ];
  };
}
