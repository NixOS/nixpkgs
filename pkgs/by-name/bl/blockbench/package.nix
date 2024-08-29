{
  lib,
  stdenv,
  buildNpmPackage,
  fetchFromGitHub,
  makeWrapper,
  imagemagick,
  copyDesktopItems,
  makeDesktopItem,
  electron
}:

let
  electronDist = "${electron}/${if stdenv.isDarwin then "Applications" else "libexec/electron"}";
in
buildNpmPackage rec {
  pname = "blockbench";
  version = "4.10.1";

  src = fetchFromGitHub {
    owner = "JannisX11";
    repo = "blockbench";
    rev = "v${version}";
    hash = "sha256-LuWxjBsOBo6tSlSGaDWrNYcTerIpU+rw3r+zN6gtYb0=";
  };

  nativeBuildInputs =
    [ makeWrapper ]
    ++ lib.optionals (!stdenv.isDarwin) [
      imagemagick # for icon resizing
      copyDesktopItems
    ];

  npmDepsHash = "sha256-CHZdCiewkmToDHhTTvOqQfWrphOw1oGLgwSRRH3YFWE=";

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = 1;

  # disable code signing on Darwin
  postConfigure = lib.optionalString stdenv.isDarwin ''
    export CSC_IDENTITY_AUTO_DISCOVERY=false
    sed -i "/afterSign/d" package.json
  '';

  npmBuildScript = "bundle";

  postBuild = ''
    # electronDist needs to be modifiable on Darwin
    cp -r ${electronDist} electron-dist
    chmod -R u+w electron-dist

    npm exec electron-builder -- \
        --dir \
        -c.electronDist=electron-dist \
        -c.electronVersion=${electron.version}
  '';

  installPhase = ''
    runHook preInstall

    ${lib.optionalString stdenv.isDarwin ''
      mkdir -p $out/Applications
      cp -r dist/mac*/Blockbench.app $out/Applications
      makeWrapper $out/Applications/Blockbench.app/Contents/MacOS/Blockbench $out/bin/blockbench
    ''}

    ${lib.optionalString (!stdenv.isDarwin) ''
      mkdir -p $out/share/blockbench
      cp -r dist/*-unpacked/{locales,resources{,.pak}} $out/share/blockbench

      for size in 16 32 48 64 128 256 512; do
        mkdir -p $out/share/icons/hicolor/"$size"x"$size"/apps
        convert -resize "$size"x"$size" icon.png $out/share/icons/hicolor/"$size"x"$size"/apps/blockbench.png
      done

      makeWrapper ${lib.getExe electron} $out/bin/blockbench \
          --add-flags $out/share/blockbench/resources/app.asar \
          --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
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
    changelog = "https://github.com/JannisX11/blockbench/releases/tag/${src.rev}";
    description = "Low-poly 3D modeling and animation software";
    homepage = "https://blockbench.net/";
    license = lib.licenses.gpl3Only;
    mainProgram = "blockbench";
    maintainers = with lib.maintainers; [
      ckie
      tomasajt
    ];
  };
}
