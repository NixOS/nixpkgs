{
  lib,
  appimageTools,
  fetchurl,
  nix-update-script,
}:

appimageTools.wrapType2 (finalAttrs: {
  pname = "nori";
  version = "0.8.0";

  src = fetchurl {
    url = "https://github.com/norifm/nori/releases/download/v${finalAttrs.version}/nori-desktop-${finalAttrs.version}-linux-x86_64.AppImage";
    hash = "sha256-6Es8SDpk3tMDTUZIvzwhnNi4CdH+atMxYi08DnJrv+4=";
  };

  # Nori's sign-in window uses the host WebKitGTK; it is intentionally not
  # bundled in the upstream AppImage.
  extraPkgs = pkgs: [
    pkgs.webkitgtk_4_1
  ];

  extraInstallCommands = ''
    install -Dm444 "${finalAttrs.contents}/dev.nori.desktop.desktop" \
      "$out/share/applications/dev.nori.desktop.desktop"
    substituteInPlace "$out/share/applications/dev.nori.desktop.desktop" \
      --replace-fail 'Exec=nori-desktop' 'Exec=nori'

    install -Dm444 "${finalAttrs.contents}/nori.png" \
      "$out/share/icons/hicolor/512x512/apps/nori.png"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    maintainers = with lib.maintainers; [ juanqp07 ];
    description = "Music player for Navidrome, Subsonic and YouTube Music";
    homepage = "https://norifm.com/";
    changelog = "https://github.com/norifm/nori/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Plus;
    mainProgram = "nori";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
