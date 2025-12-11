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
  patchelf,
  nix-update-script,
  undmg,
  makeWrapper,
}:
let
  pname = "nextcloud-talk-desktop";
  version = "2.0.4";

  # Only x86_64-linux is supported with Darwin support being universal
  sources = {
    # Building from source would require building also building Server and Talk components
    # See https://github.com/nextcloud/talk-desktop?tab=readme-ov-file#%EF%B8%8F-prerequisites
    linux = fetchzip {
      url = "https://github.com/nextcloud-releases/talk-desktop/releases/download/v${version}/Nextcloud.Talk-linux-x64.zip";
      hash = "sha256-Nky3ws1UV0F4qjbBog53BjXkZ/ttTER/32NlB2ONJaE=";
      stripRoot = false;
    };
    darwin = fetchurl {
      url = "https://github.com/nextcloud-releases/talk-desktop/releases/download/v${version}/Nextcloud.Talk-macos-universal.dmg";
      hash = "sha256-FgiUb2MNEqmbK4BphHQ7M2IeN7Vg1NQ9FR9UO4AfvNs=";
    };
  };

  meta = {
    description = "Nextcloud Talk Desktop Client";
    homepage = "https://github.com/nextcloud/talk-desktop";
    changelog = "https://github.com/nextcloud/talk-desktop/blob/${version}/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ kashw2 ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    mainProgram = "nextcloud-talk-desktop";
  };

  linux = stdenv.mkDerivation (finalAttrs: {
    inherit pname version;

    src = sources.linux;

    icon = fetchurl {
      url = "https://raw.githubusercontent.com/nextcloud/talk-desktop/refs/tags/v${version}/img/icons/icon.png";
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

    postFixup = ''
      patchelf --add-needed libGL.so.1 --add-needed libEGL.so.1 \
        "$out/opt/Nextcloud Talk-linux-x64/Nextcloud Talk"
    '';

    passthru.updateScript = nix-update-script { };

    meta = meta // {
      platforms = lib.intersectLists lib.platforms.linux lib.platforms.x86_64;
    };
  });

  darwin = stdenv.mkDerivation (finalAttrs: {
    inherit pname version;

    src = sources.darwin;

    nativeBuildInputs = [
      undmg
      makeWrapper
    ];

    sourceRoot = ".";

    installPhase = ''
      runHook preInstall

      mkdir -p $out/{Applications,bin}
      mv Nextcloud\ Talk.app/Contents $out/Applications/

      makeWrapper $out/Applications/Contents/MacOS/Nextcloud\ Talk $out/bin/nextcloud-talk-desktop

      runHook postInstall
    '';

    meta = meta // {
      platforms = lib.platforms.darwin;
    };
  });
in
if stdenv.hostPlatform.isDarwin then darwin else linux
