{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchYarnDeps,
  nodejs,
  electron,
  yarnConfigHook,
  yarnBuildHook,
  makeWrapper,
  imagemagick,
  applyPatches,
  makeDesktopItem,
  copyDesktopItems,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pomatez";
  version = "1.9.0";

  src = applyPatches {
    src = fetchFromGitHub {
      owner = "zidoro";
      repo = "pomatez";
      tag = "v${finalAttrs.version}";
      hash = "sha256-IHzdd9iamK14MFEEbJch3YTWE0nFGQWoinu/d0Tr6ls=";
    };
    patches = [
      # Checking for updates is broken somehow due to a missing file (an issue with packaging),
      # but the related code also provides a self-update feature, which we want to disable anyway.
      ./0001-disable-auto-update.patch
      # XXX: This enables nodeIntegration which is insecure, as it disables sandboxing.
      # Pomatez upstream pins archaic electron version v18, where node integration is still allowed by default.
      # Without this patch, latest electron (which we use) fails loading @pomatez/shareables node module, completely breaking rendering.
      ./0002-insecure-enable-node-integration.patch
    ];
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-y3BAsd6ACcGLH+6X+MCEQMS9wNZJR6SBTFJmyUnoL0w=";
  };

  nativeBuildInputs = [
    nodejs
    makeWrapper
    imagemagick
    yarnConfigHook
    yarnBuildHook
    copyDesktopItems
  ];

  # FIXME: These scripts unnecessarily build 2 systems at once (x86_64 and aarch64).
  yarnBuildScript = if stdenv.hostPlatform.isDarwin then "build:mac" else "build:linux";

  yarnBuildFlags = [
    "--" # Additional 2 "--" are needed so lerna passes the flags to electron-builder.
    "--"
    "--dir"
    "-c.electronDist=${electron.dist}"
    "-c.electronVersion=${electron.version}"
  ];

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  installPhase =
    let
      electronBuilderOutputDirBySystem = {
        "x86_64-linux" = "linux-unpacked";
        "aarch64-linux" = "linux-arm64-unpacked";
        "x86_64-darwin" = "mac";
        "aarch64-darwin" = "mac-arm64";
      };
    in
    ''
      runHook preInstall

      for size in 16 24 32 48 64 128 256; do
        mkdir -p $out/share/icons/hicolor/"$size"x"$size"/apps
        magick convert -background none -resize "$size"x"$size" snap/gui/icon.png $out/share/icons/hicolor/"$size"x"$size"/apps/pomatez.png
      done

      cd app/electron/dist/${electronBuilderOutputDirBySystem.${stdenv.hostPlatform.system}}
      mkdir -p $out/share/pomatez
      cp -r ./* $out/share/pomatez

      makeWrapper '${electron}/bin/electron' "$out/bin/pomatez" \
        --add-flags "$out/share/pomatez/resources/app.asar" \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
        --set-default ELECTRON_FORCE_IS_PACKAGED 1 \
        --set-default ELECTRON_IS_DEV 0 \

      runHook postInstall
    '';

  desktopItems = [
    (makeDesktopItem {
      name = "pomatez";
      exec = "pomatez";
      icon = "pomatez";
      desktopName = "Pomatez";
      genericName = "Pomodoro timer";
      comment = finalAttrs.meta.description;
      categories = [
        "Office"
        "Utility"
      ];
    })
  ];

  meta = {
    description = "Elegant multi-platform Pomodoro desktop app, built with Electron";
    homepage = "https://zidoro.github.io/pomatez/";
    changelog = "https://github.com/zidoro/pomatez/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "pomatez";
    maintainers = with lib.maintainers; [ rszyma ];
    inherit (electron.meta) platforms;
  };
})
