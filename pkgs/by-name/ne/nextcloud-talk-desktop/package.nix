{
  lib,
  stdenv,
  fetchurl,
  fetchzip,
  autoPatchelfHook,
  copyDesktopItems,
  makeDesktopItem,
  nss,
  cairo,
  xorg,
  libxkbcommon,
  alsa-lib,
  at-spi2-core,
  libgbm,
  pango,
  libdrm,
  vivaldi-ffmpeg-codecs,
  gtk3,
  libGL,
  libglvnd,
  systemd,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nextcloud-talk-desktop";
  version = "1.2.6";

  # Building from source would require building also building Server and Talk components
  # See https://github.com/nextcloud/talk-desktop?tab=readme-ov-file#%EF%B8%8F-prerequisites
  src = fetchzip {
    url = "https://github.com/nextcloud-releases/talk-desktop/releases/download/v${finalAttrs.version}/Nextcloud.Talk-linux-x64.zip";
    hash = "sha256-uCqmcDZ5iaeT8nCss3Y2nen4N5nzMKu0dkTU/gapVow=";
    stripRoot = false;
  };

  icon = fetchurl {
    url = "https://raw.githubusercontent.com/nextcloud/talk-desktop/refs/tags/v1.0.0/img/icons/icon.png";
    hash = "sha256-DteSSuxIs0ukIJrvUO/3Mrh5F2GG5UAVvGRZUuZonkg=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
  ];

  buildInputs = [
    nss
    cairo
    alsa-lib
    at-spi2-core
    pango
    libdrm
    libxkbcommon
    gtk3
    vivaldi-ffmpeg-codecs
    libgbm
    libGL
    libglvnd
  ]
  ++ (with xorg; [
    libX11
    libXcomposite
    libXdamage
    libXrandr
    libXfixes
    libXcursor
  ]);

  # Required to launch the application and proceed past the zygote_linux fork() process
  # Fixes `Zygote could not fork`
  runtimeDependencies = [ systemd ];

  desktopItems = [
    (makeDesktopItem {
      type = "Application";
      name = "nextcloud-talk-desktop";
      desktopName = "Nextcloud Talk";
      comment = finalAttrs.meta.description;
      exec = finalAttrs.meta.mainProgram;
      icon = "nextcloud-talk-desktop";
      categories = [ "Chat" ];
    })
  ];

  preInstall = ''
    mkdir -p $out/bin
    mkdir -p $out/opt

    cp -r $src/* $out/opt/
  '';

  installPhase = ''
    runHook preInstall

    # Link the application in $out/bin away from contents of `preInstall`
    ln -s "$out/opt/Nextcloud Talk-linux-x64/Nextcloud Talk" $out/bin/nextcloud-talk-desktop
    mkdir -p $out/share/icons/hicolor/512x512/apps
    cp $icon $out/share/icons/hicolor/512x512/apps/nextcloud-talk-desktop.png

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Nextcloud Talk Desktop Client";
    homepage = "https://github.com/nextcloud/talk-desktop";
    changelog = "https://github.com/nextcloud/talk-desktop/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ kashw2 ];
    mainProgram = "nextcloud-talk-desktop";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
  };
})
