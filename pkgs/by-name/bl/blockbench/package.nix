{
  lib,
  stdenv,
  buildNpmPackage,
  fetchFromGitHub,
  fetchpatch,
  makeWrapper,
  imagemagick,
  copyDesktopItems,
  makeDesktopItem,
  electron,
}:

buildNpmPackage rec {
  pname = "blockbench";
  version = "5.0.7";

  src = fetchFromGitHub {
    owner = "JannisX11";
    repo = "blockbench";
    tag = "v${version}";
    hash = "sha256-JXOO2+UPMOGSuvez8ektbD5waPKatMggKn+MuH9Qkrs=";
  };

  nativeBuildInputs = [
    makeWrapper
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    imagemagick # for icon resizing
    copyDesktopItems
  ];

  patches = [
    (fetchpatch {
      # fixes https://github.com/JannisX11/blockbench/issues/3237
      name = "bump-electron-builder.patch";
      url = "https://github.com/JannisX11/blockbench/commit/dee9ae271f252d4bb3f98c13c4a1abaaeedd1feb.patch";
      hash = "sha256-XpdqeCKoWsUieOMWhxVsEQ2r0qR+iiXKnVRfNYERDQs=";
    })
  ];

  npmDepsHash = "sha256-T3yenZCkOrGOWJBxqe0RG39jWYfpsXStblf5Jx4dtF0=";
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
