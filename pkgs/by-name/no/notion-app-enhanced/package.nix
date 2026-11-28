{
  appimageTools,
  lib,
  fetchurl,
}:
appimageTools.wrapType2 (finalAttrs: {
  pname = "notion-app-enhanced";
  version = "2.0.18-1";
  src = fetchurl {
    url = "https://github.com/notion-enhancer/notion-repackaged/releases/download/v${finalAttrs.version}/Notion-Enhanced-${finalAttrs.version}.AppImage";
    sha256 = "sha256-SqeMnoMzxxaViJ3NPccj3kyMc1xvXWULM6hQIDZySWY=";
  };

  extraInstallCommands = ''
    install -m 444 -D ${finalAttrs.contents}/${finalAttrs.pname}.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/${finalAttrs.pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=${finalAttrs.pname}'
    cp -r ${finalAttrs.contents}/usr/share/icons $out/share
  '';

  meta = {
    description = "Notion Desktop builds with Notion Enhancer for Windows, macOS and Linux";
    homepage = "https://github.com/notion-enhancer/desktop";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ sei40kr ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "notion-app-enhanced";
  };
})
