{
  lib,
  appimageTools,
  fetchurl,
  makeWrapper,
}:

appimageTools.wrapAppImage rec {
  pname = "protonup-qt";
  version = "2.15.0";

  src = appimageTools.extractType2 {
    inherit pname version;
    inherit (passthru) src;
  };

  nativeBuildInputs = [ makeWrapper ];

  extraInstallCommands = ''
    install -Dm644 ${src}/net.davidotek.pupgui2.desktop $out/share/applications/protonup-qt.desktop
    install -Dm644 ${src}/net.davidotek.pupgui2.png $out/share/pixmaps/protonup-qt.png
    substituteInPlace $out/share/applications/protonup-qt.desktop \
      --replace-fail "Exec=net.davidotek.pupgui2" "Exec=protonup-qt" \
      --replace-fail "Icon=net.davidotek.pupgui2" "Icon=protonup-qt"
    wrapProgram $out/bin/protonup-qt \
      --unset QT_PLUGIN_PATH \
      --unset QML2_IMPORT_PATH
  '';

  extraPkgs = pkgs: with pkgs; [ zstd ];

  passthru = {
    src = fetchurl {
      # for update script
      url = "https://github.com/DavidoTek/ProtonUp-Qt/releases/download/v${version}/ProtonUp-Qt-${version}-x86_64.AppImage";
      hash = "sha256-FzrgOlEmC+4fvd32Btl18+b6eRWaSeTxCLg7K8VZ0dI=";
    };
    updateScript = ./update.sh;
  };

  meta = {
    homepage = "https://davidotek.github.io/protonup-qt/";
    description = "Install and manage Proton-GE and Luxtorpeda for Steam and Wine-GE for Lutris with this graphical user interface";
    license = lib.licenses.gpl3Plus;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "protonup-qt";
    changelog = "https://github.com/DavidoTek/ProtonUp-Qt/releases/tag/v${version}";
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ michaelBelsanti ];
  };
}
