{
  stdenv,
  fetchurl,
  autoPatchelfHook,
  dpkg,
  makeBinaryWrapper,
  gtk4,
  alsa-lib,
  lib,
  libxtst,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "meshtastic-desktop";
  version = "2.7.14";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchurl {
    url = "https://github.com/meshtastic/Meshtastic-Android/releases/download/v${finalAttrs.version}-open.14/meshtastic-desktop_${finalAttrs.version}_amd64.deb";
    hash = "sha256-zwXuOQ70gBlNgcE7yDKOxQ0SEbNvDfFxD5+pRcPW1wQ=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    makeBinaryWrapper
  ];

  buildInputs = [
    gtk4
    alsa-lib
    libxtst
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p {$out,$out/bin,$out/share}
    cp -a opt/meshtastic-desktop $out/share/
    ln -s "$out/share/meshtastic-desktop/bin/Meshtastic Desktop" $out/bin/

    install -Dm644 opt/meshtastic-desktop/lib/meshtastic-desktop-Meshtastic_Desktop.desktop $out/share/applications/Meshtastic_Desktop.desktop

    substituteInPlace $out/share/applications/Meshtastic_Desktop.desktop \
      --replace-fail "/opt/meshtastic-desktop/bin/Meshtastic Desktop" "Meshtastic Desktop" \
      --replace-fail "/opt/meshtastic-desktop/lib/Meshtastic_Desktop.png" "Meshtastic_Desktop.png"

    install -Dm655 -t $out/share/icons/hicolor/scalable/apps opt/meshtastic-desktop/lib/Meshtastic_Desktop.png

    runHook postInstall
  '';

  meta = {
    description = "Desktop application for Meshtastic";
    mainProgram = "Meshtastic Desktop";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ drupol ];
  };
})
