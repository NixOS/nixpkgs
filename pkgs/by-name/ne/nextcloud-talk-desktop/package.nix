{ lib
, stdenv
, fetchzip
, autoPatchelfHook

, nss
, cairo
, xorg
, libxkbcommon
, alsa-lib
, at-spi2-core
, mesa
, pango
, libdrm
, vivaldi-ffmpeg-codecs
, gtk3
, libGL
, libglvnd
, systemd
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nextcloud-talk-desktop";
  version = "0.29.0";

  # Building from source would require building also building Server and Talk components
  # See https://github.com/nextcloud/talk-desktop?tab=readme-ov-file#%EF%B8%8F-prerequisites
  src = fetchzip {
    url = "https://github.com/nextcloud-releases/talk-desktop/releases/download/v${finalAttrs.version}/Nextcloud.Talk-linux-x64-${finalAttrs.version}.zip";
    hash = "sha256-fBIeNv8tfrVTFExLQDBPhIazvbsJ7a76+W9G0cuQDlw=";
    stripRoot = false;
  };

  nativeBuildInputs = [ autoPatchelfHook ];

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
    mesa
    libGL
    libglvnd
  ] ++ (with xorg; [libX11 libXcomposite libXdamage libXrandr libXfixes libXcursor]);

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
    ln -s "$out/opt/Nextcloud Talk" $out/bin/${finalAttrs.pname}

    runHook postInstall
  '';

  meta = with lib; {
    description = "Nextcloud Talk Desktop Client Preview";
    homepage = "https://github.com/nextcloud/talk-desktop";
    changelog = "https://github.com/nextcloud/talk-desktop/blob/${finalAttrs.version}/CHANGELOG.md";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ kashw2 ];
    mainProgram = finalAttrs.pname;
  };
})
