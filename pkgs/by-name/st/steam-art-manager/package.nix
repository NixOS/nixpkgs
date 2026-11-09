{
  lib,
  fetchurl,
  appimageTools,
}:

appimageTools.wrapType2 (finalAttrs: {
  pname = "steam-art-manager";
  version = "3.23.2";
  src = fetchurl {
    url = "https://github.com/Tormak9970/Steam-Art-Manager/releases/download/v${finalAttrs.version}/steam-art-manager.AppImage";
    hash = "sha256-pu++TG4GwniZYl2SOGjVzRmrQQfJRgwZkfznmX5j/Hg=";
  };

  extraInstallCommands = ''
    install -m 444 -D "${finalAttrs.contents}/usr/share/applications/Steam Art Manager.desktop" $out/share/applications/steam-art-manager.desktop
    install -m 444 -D "${finalAttrs.contents}/Steam Art Manager.png" $out/share/icons/hicolor/512x512/apps/steam-art-manager.png
    substituteInPlace $out/share/applications/steam-art-manager.desktop \
      --replace 'Exec=AppRun' 'Exec=${finalAttrs.pname}' \
      --replace 'Icon=Steam Art Manager' 'Icon=steam-art-manager'
  '';

  meta = {
    description = "A tool to manage and change Steam library artwork";
    homepage = "https://github.com/Tormak9970/Steam-Art-Manager";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ adam-tj ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "steam-art-manager";
  };
})
