{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  electron,
  copyDesktopItems,
  makeDesktopItem,
  nix-update-script,
  makeWrapper,
  ivpn-service,
}:
let
  version = "3.14.34";
in
buildNpmPackage {
  pname = "ivpn-ui";
  inherit version;

  src = fetchFromGitHub {
    owner = "ivpn";
    repo = "desktop-app";
    tag = "v${version}";
    hash = "sha256-Q96G5mJahJnXxpqJ8IF0oFie7l0Nd1p8drHH9NSpwEw=";
  };

  sourceRoot = "source/ui";

  npmDepsHash = "sha256-y/VxvSZUvcIuckJF87639i5pcVJLg8SDAbWmg5bO3/s=";

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
  ];

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = 1;
  };

  postBuild = ''
    cp -r ${electron.dist} electron-dist
    chmod -R u+w electron-dist

    npm exec electron-builder -- \
      --dir \
      -c.electronDist=electron-dist \
      -c.electronVersion=${electron.version} \
      --config electron-builder.config.js
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/ivpn-ui
    cp -r dist/*-unpacked/{locales,resources{,.pak}} $out/share/ivpn-ui

    install -Dm644 $src/ui/References/Linux/ui/ivpnicon.svg $out/share/icons/hicolor/scalable/apps/ivpn-ui.svg

    makeWrapper ${lib.getExe electron} $out/bin/ivpn-ui \
      --prefix PATH : ${lib.makeBinPath [ ivpn-service ]} \
      --add-flags $out/share/ivpn-ui/resources/app.asar \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
      --inherit-argv0

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "ivpn-ui";
      type = "Application";
      desktopName = "IVPN";
      genericName = "VPN Client";
      comment = "UI interface for IVPN";
      icon = "ivpn-ui";
      exec = "ivpn-ui";
      categories = [ "Network" ];
      startupNotify = true;
    })
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "UI interface for IVPN";
    mainProgram = "ivpn-ui";
    homepage = "https://www.ivpn.net";
    downloadPage = "https://github.com/ivpn/desktop-app";
    changelog = "https://github.com/ivpn/desktop-app/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ blenderfreaky ];
    platforms = [ "x86_64-linux" ];
  };
}
