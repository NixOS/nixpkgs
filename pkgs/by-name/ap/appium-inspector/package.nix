{
  lib,
  buildNpmPackage,
  copyDesktopItems,
  electron_36,
  fetchFromGitHub,
  makeDesktopItem,
  makeWrapper,
  nix-update-script,
}:

let
  electron = electron_36;
  version = "2025.3.1";
in

buildNpmPackage {
  pname = "appium-inspector";
  inherit version;

  src = fetchFromGitHub {
    owner = "appium";
    repo = "appium-inspector";
    tag = "v${version}";
    hash = "sha256-Qpk3IXoegPKLKdSSzY05cT2//45TIhyVLxESd2OeWPE=";
  };

  npmDepsHash = "sha256-vUqX8yUZCflfkDYssQelFfJLNhDeU3K4UJPPgvvEeaI=";
  npmFlags = [ "--ignore-scripts" ];

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
  ];

  buildPhase = ''
    runHook preBuild

    npm run build:electron
    npm exec electron-builder -- \
      --dir \
      -c.electronDist=${electron.dist} \
      -c.electronVersion=${electron.version}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/appium-inspector"
    cp -r release/*-unpacked/resources "$out/share/appium-inspector/"

    makeWrapper '${electron}/bin/electron' "$out/bin/appium-inspector" \
      --add-flags "$out/share/appium-inspector/resources/app.asar" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
      --set NODE_ENV production

    install -m 444 -D 'app/common/renderer/assets/images/icon.png' \
      $out/share/icons/hicolor/512x512/apps/appium-inspector.png

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "appium-inspector";
      exec = "appium-inspector";
      desktopName = "Appium Inspector";
      comment = "A GUI inspector for mobile apps and more, powered by a (separately installed) Appium server";
      categories = [ "Development" ];
      icon = "appium-inspector";
    })
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "GUI inspector for the appium UI automation tool";
    homepage = "https://appium.github.io/appium-inspector";
    changelog = "https://github.com/appium/appium-inspector/releases/tag/v${version}";
    license = lib.licenses.asl20;
    mainProgram = "appium-inspector";
    maintainers = with lib.maintainers; [ marie ];
    platforms = lib.platforms.linux;
  };
}
