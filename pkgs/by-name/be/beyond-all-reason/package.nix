{
  lib,
  fetchurl,
  appimageTools,
  openal,
}:

appimageTools.wrapType2 (finalAttrs: {
  version = "1.2988.0";
  pname = "beyond-all-reason";

  src = fetchurl {
    url = "https://github.com/beyond-all-reason/BYAR-Chobby/releases/download/v${finalAttrs.version}/Beyond-All-Reason-${finalAttrs.version}.AppImage";
    hash = "sha256-ZJW5BdxxqyrM2TJTO0SBp4BXt3ILyi77EZx73X8hqJE=";
  };

  extraPkgs = pkgs: [ openal ];

  extraInstallCommands = ''
    install -m 444 -D ${finalAttrs.contents}/beyond-all-reason.desktop $out/share/applications/beyond-all-reason.desktop
    install -m 444 -D ${finalAttrs.contents}/beyond-all-reason.png \
      $out/share/icons/hicolor/256x256/apps/beyond-all-reason.png
    substituteInPlace $out/share/applications/beyond-all-reason.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=beyond-all-reason'
  '';

  meta = {
    homepage = "https://www.beyondallreason.info/";
    downloadPage = "https://www.beyondallreason.info/download";
    changelog = "https://github.com/beyond-all-reason/BYAR-Chobby/releases/tag/v${finalAttrs.version}";
    description = "Free Real Time Strategy Game with a grand scale and full physical simulation in a sci-fi setting";
    license = lib.licenses.gpl2Plus;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [
      kiyotoko
    ];
  };
})
