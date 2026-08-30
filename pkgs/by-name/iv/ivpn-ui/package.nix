{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  electron_42,
  copyDesktopItems,
  makeDesktopItem,
  nix-update-script,
  makeWrapper,
  ivpn-service,
}:
buildNpmPackage (finalAttrs: {
  pname = "ivpn-ui";
  version = "3.15.13";

  src = fetchFromGitHub {
    owner = "ivpn";
    repo = "desktop-app";
    tag = "v${finalAttrs.version}";
    hash = "sha256-F5MhJ09ioqL4Xf4r2cdXUKmkK8ebj/qRFWfxKuodH3k=";
  };

  sourceRoot = "source/ui";

  npmDepsHash = "sha256-Q8qrAo7+GrbUUx33t89/N4WHnJLbdpMSpBm5rLclJC0=";

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
  ];

  # electron 42's install.js no longer honors ELECTRON_SKIP_BINARY_DOWNLOAD and
  # unconditionally downloads the electron binary.
  # install-app-deps is a no-op here, so drop the whole postinstall,
  # that way the electron download is skipped properly.
  postPatch = ''
    substituteInPlace package.json \
      --replace-fail '"postinstall": "node node_modules/electron/install.js && electron-builder install-app-deps",' ""
  '';

  postBuild = ''
    electron_dist="$(mktemp -d)"
    cp -r ${electron_42.dist}/. "$electron_dist"
    chmod -R u+w "$electron_dist"

    npm exec electron-builder -- \
      --dir \
      -c.electronDist="$electron_dist" \
      -c.electronVersion=${electron_42.version} \
      --config electron-builder.config.js
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/ivpn-ui
    cp -r dist/*-unpacked/{locales,resources{,.pak}} $out/share/ivpn-ui

    install -Dm644 $src/ui/References/Linux/ui/ivpnicon.svg $out/share/icons/hicolor/scalable/apps/ivpn-ui.svg

    makeWrapper ${lib.getExe electron_42} $out/bin/ivpn-ui \
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
    changelog = "https://github.com/ivpn/desktop-app/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ kilyanni ];
    platforms = [ "x86_64-linux" ];
  };
})
