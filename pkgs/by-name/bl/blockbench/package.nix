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
  version = "4.12.6";

  src = fetchFromGitHub {
    owner = "JannisX11";
    repo = "blockbench";
    tag = "v${version}";
    hash = "sha256-iV8qpUsUnL1n6hKADegNTmrW/AUWNiiNLxrTU4WPR30=";
  };

  nativeBuildInputs = [
    makeWrapper
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    imagemagick # for icon resizing
    copyDesktopItems
  ];

  npmDepsHash = "sha256-ZLFmcK91SrUM+ouBENzc+MdNvQCRDh0ej4tf2TneUtQ=";

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = 1;

  # disable code signing on Darwin
  postConfigure = lib.optionalString stdenv.hostPlatform.isDarwin ''
    export CSC_IDENTITY_AUTO_DISCOVERY=false
    sed -i "/afterSign/d" package.json
  '';

  npmBuildScript = "bundle";

  postBuild = ''
    # electronDist needs to be modifiable on Darwin
    cp -r ${electron.dist} electron-dist
    chmod -R u+w electron-dist

    npm exec electron-builder -- \
        --dir \
        -c.electronDist=electron-dist \
        -c.electronVersion=${electron.version}
  '';

  installPhase = ''
    runHook preInstall

    ${lib.optionalString stdenv.hostPlatform.isDarwin ''
      mkdir -p $out/Applications
      cp -r dist/mac*/Blockbench.app $out/Applications
      makeWrapper $out/Applications/Blockbench.app/Contents/MacOS/Blockbench $out/bin/blockbench
    ''}

    ${lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
      mkdir -p $out/share/blockbench
      cp -r dist/*-unpacked/{locales,resources{,.pak}} $out/share/blockbench

      for size in 16 32 48 64 128 256 512; do
        mkdir -p $out/share/icons/hicolor/"$size"x"$size"/apps
        magick icon.png -resize "$size"x"$size" $out/share/icons/hicolor/"$size"x"$size"/apps/blockbench.png
      done

      makeWrapper ${lib.getExe electron} $out/bin/blockbench \
          --add-flags $out/share/blockbench/resources/app.asar \
          --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
          --inherit-argv0
    ''}

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
