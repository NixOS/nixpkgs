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
<<<<<<< HEAD
=======
  nix-update-script,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  undmg,
  makeWrapper,
}:
let
  pname = "nextcloud-talk-desktop";
<<<<<<< HEAD
  version = "2.0.5"; # Ensure both hashes (Linux and Darwin) are updated!

  hashes = {
    linux = "sha256-aKNrIbv6kaLoLmTZVgwncqzF4o/5C/hFXef3QqM7oBk=";
    darwin = "sha256-Nli2z8eyAq5W3ALwHiH6+Ightk3Jf0gaWtwabOJS4gw=";
  };
=======
  version = "2.0.3";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  # Only x86_64-linux is supported with Darwin support being universal
  sources = {
    # Building from source would require building also building Server and Talk components
    # See https://github.com/nextcloud/talk-desktop?tab=readme-ov-file#%EF%B8%8F-prerequisites
    linux = fetchzip {
      url = "https://github.com/nextcloud-releases/talk-desktop/releases/download/v${version}/Nextcloud.Talk-linux-x64.zip";
<<<<<<< HEAD
      hash = hashes.linux;
=======
      hash = "sha256-QKbg5vHLuxLpngrHom/odWw9RK43jhZsEg7Df5c7db0=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      stripRoot = false;
    };
    darwin = fetchurl {
      url = "https://github.com/nextcloud-releases/talk-desktop/releases/download/v${version}/Nextcloud.Talk-macos-universal.dmg";
<<<<<<< HEAD
      hash = hashes.darwin;
    };
  };

  passthru = {
    inherit hashes; # needed by updateScript
    updateScript = ./update.py;
  };

=======
      hash = "sha256-FgiUb2MNEqmbK4BphHQ7M2IeN7Vg1NQ9FR9UO4AfvNs=";
    };
  };

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
    inherit pname version passthru;
=======
    inherit pname version;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
<<<<<<< HEAD
      ${lib.getExe patchelf} --add-needed libGL.so.1 --add-needed libEGL.so.1 \
        "$out/opt/Nextcloud Talk-linux-x64/Nextcloud Talk"
    '';

=======
      patchelf --add-needed libGL.so.1 --add-needed libEGL.so.1 \
        "$out/opt/Nextcloud Talk-linux-x64/Nextcloud Talk"
    '';

    passthru.updateScript = nix-update-script { };

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    meta = meta // {
      platforms = lib.intersectLists lib.platforms.linux lib.platforms.x86_64;
    };
  });

  darwin = stdenv.mkDerivation (finalAttrs: {
<<<<<<< HEAD
    inherit pname version passthru;
=======
    inherit pname version;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
