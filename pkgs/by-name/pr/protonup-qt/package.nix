{
  lib,
  appimageTools,
  fetchurl,
  makeWrapper,
  nix-update-script,
}:

let
  appId = "net.davidotek.pupgui2";
in
appimageTools.wrapType2 (finalAttrs: {
  pname = "protonup-qt";
  version = "2.16.0";

  src = fetchurl {
    url = "https://github.com/DavidoTek/ProtonUp-Qt/releases/download/v${finalAttrs.version}/ProtonUp-Qt-${finalAttrs.version}-x86_64.AppImage";
    hash = "sha256-hipxdQLwuWAfI+hJpLTf49aa7X58omLPG9xKVT+N5+w=";
  };

  extraPkgs = pkgs: [ pkgs.zstd ];

  nativeBuildInputs = [ makeWrapper ];

  extraInstallCommands = ''
    cp -r ${finalAttrs.contents}/usr/share $out
    chmod -R u+w $out/share
    substituteInPlace $out/share/applications/${appId}.desktop \
      --replace-fail "Exec=${appId}" "Exec=${finalAttrs.meta.mainProgram}"

    wrapProgram $out/bin/${finalAttrs.meta.mainProgram} \
      --unset QT_PLUGIN_PATH \
      --unset QML2_IMPORT_PATH
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Install and manage Proton-GE and Luxtorpeda for Steam and Wine-GE for Lutris with this graphical user interface";
    homepage = "https://davidotek.github.io/protonup-qt/";
    changelog = "https://github.com/DavidoTek/ProtonUp-Qt/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ michaelBelsanti ];
    mainProgram = "protonup-qt";
    platforms = [ "x86_64-linux" ];
  };
})
