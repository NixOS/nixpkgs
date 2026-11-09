{
  appimageTools,
  lib,
  fetchurl,
  nix-update-script,
  makeDesktopItem,
}:

appimageTools.wrapType2 (finalAttrs: {
  pname = "simplenote";
  version = "2.27.1";
  src = fetchurl {
    url = "https://github.com/Automattic/simplenote-electron/releases/download/v${finalAttrs.version}/Simplenote-linux-${finalAttrs.version}-x86_64.AppImage";
    hash = "sha512-jf9mnmf+5Xcowxgx7uizWVmv88gPdYwojQ2f+xhbqnXaHD3dSbcW2YdxiV3qjmFsRzUgwZvBVOGpOMvnSHuQDA==";
  };

  extraInstallCommands = ''
    install -m 444 -D ${finalAttrs.contents}/${finalAttrs.pname}.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/${finalAttrs.pname}.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=${finalAttrs.pname}'

    cp -r ${finalAttrs.contents}/usr/share/icons $out/share
  '';

  extraPkgs =
    pkgs: with pkgs; [
      libsecret
      libnotify
      libappindicator
    ];

  desktopItems = [
    (makeDesktopItem {
      name = finalAttrs.pname;
      desktopName = "Simplenote";
      exec = finalAttrs.pname;
      icon = "simplenote";
      genericName = "Note Taking Application";
      comment = "Simplenote for Linux";
      categories = [ "Utility" ];
      startupNotify = true;
    })
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    mainProgram = "simplenote";
    description = "The simplest way to keep notes";
    homepage = "https://github.com/Automattic/simplenote-electron";
    license = lib.licenses.gpl2Plus;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ _2zqa ];
    changelog = "https://github.com/Automattic/simplenote-electron/releases/tag/v${finalAttrs.version}/RELEASE-NOTES.md";
  };
})
