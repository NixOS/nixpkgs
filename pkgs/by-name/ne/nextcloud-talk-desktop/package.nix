{
  lib,
  stdenv,
  fetchzip,
  autoPatchelfHook,
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
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nextcloud-talk-desktop";
  version = "1.0.1";

  # Building from source would require building also building Server and Talk components
  # See https://github.com/nextcloud/talk-desktop?tab=readme-ov-file#%EF%B8%8F-prerequisites
  src = fetchzip {
    url = "https://github.com/nextcloud-releases/talk-desktop/releases/download/v${finalAttrs.version}/Nextcloud.Talk-linux-x64.zip";
    hash = "sha256-ZSNeuKZ+oi6tHO61RshtJ6ndtxvUJbY4gyhDwKpHXZI=";
    stripRoot = false;
  };

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs =
    [
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

  preInstall = ''
    mkdir -p $out/bin
    mkdir -p $out/opt

    cp -r $src/* $out/opt/
  '';

  installPhase = ''
    runHook preInstall

    # Link the application in $out/bin away from contents of `preInstall`
    ln -s "$out/opt/Nextcloud Talk-linux-x64/Nextcloud Talk" $out/bin/nextcloud-talk-desktop

    runHook postInstall
  '';

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
