{
  lib,
  appimageTools,
  fetchurl,
  makeWrapper,
  nix-update-script,
}:
appimageTools.wrapType2 (finalAttrs: {
  pname = "protonup-qt";
  version = "2.15.1";
  src = fetchurl {
    url = "https://github.com/DavidoTek/ProtonUp-Qt/releases/download/v${finalAttrs.version}/ProtonUp-Qt-${finalAttrs.version}-x86_64.AppImage";
    hash = "sha256-/Xjvsf+gkHpSV4RGJJS5tCk4+f18AZ8+rqO4+vg36ME=";
  };

  nativeBuildInputs = [ makeWrapper ];

  extraInstallCommands = ''
    install -Dm644 ${finalAttrs.contents}/net.davidotek.pupgui2.desktop $out/share/applications/protonup-qt.desktop
    install -Dm644 ${finalAttrs.contents}/net.davidotek.pupgui2.png $out/share/pixmaps/protonup-qt.png
    substituteInPlace $out/share/applications/protonup-qt.desktop \
      --replace-fail "Exec=net.davidotek.pupgui2" "Exec=protonup-qt" \
      --replace-fail "Icon=net.davidotek.pupgui2" "Icon=protonup-qt"
    wrapProgram $out/bin/protonup-qt \
      --unset QT_PLUGIN_PATH \
      --unset QML2_IMPORT_PATH
  '';

  extraPkgs = pkgs: with pkgs; [ zstd ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://davidotek.github.io/protonup-qt/";
    description = "Install and manage Proton-GE and Luxtorpeda for Steam and Wine-GE for Lutris with this graphical user interface";
    license = lib.licenses.gpl3Plus;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "protonup-qt";
    changelog = "https://github.com/DavidoTek/ProtonUp-Qt/releases/tag/v${finalAttrs.version}";
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ michaelBelsanti ];
  };
})
