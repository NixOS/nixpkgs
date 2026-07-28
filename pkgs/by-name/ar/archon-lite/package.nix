{
  lib,
  appimageTools,
  fetchurl,
  nix-update-script,
}:

appimageTools.wrapType2 (finalAttrs: {
  pname = "archon-lite";
  version = "9.4.36";

  src = fetchurl {
    url = "https://github.com/RPGLogs/Uploaders-archon-lite/releases/download/v${finalAttrs.version}/archon-lite-v${finalAttrs.version}.AppImage";
    hash = "sha256-th48nSDIi2iugtiqjgkI7/QZtBq+BRQjRs1pKweDArI=";
  };

  extraInstallCommands = ''
    mkdir -p $out/share/applications
    mkdir -p $out/share/icons/hicolor/512x512/apps
    cp -r ${finalAttrs.contents}/usr/share/icons/hicolor/512x512/apps/'Archon App Lite.png' $out/share/icons/hicolor/512x512/apps/archon-lite.png
    chmod -R +w $out/share/
    test ! -e $out/share/icons/hicolor/0x0 # check for regression of https://github.com/electron-userland/electron-builder/issues/5294
    cp ${finalAttrs.contents}/'Archon App Lite.desktop' $out/share/applications/archon-lite.desktop
    substituteInPlace $out/share/applications/archon-lite.desktop \
      --replace-fail "Exec=AppRun --no-sandbox" "Exec=archon-lite" \
      --replace-fail "Icon=Archon App Lite" "Icon=archon-lite"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Application for uploading MMORPG combat logs";
    homepage = "https://www.archon.gg/download";
    downloadPage = "https://github.com/RPGLogs/Uploaders-archon-lite/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.unfree; # no license listed
    mainProgram = "archon-lite";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      hekazu
      sophiebsw
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
