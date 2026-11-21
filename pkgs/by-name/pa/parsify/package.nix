{
  lib,
  appimageTools,
  fetchurl,
}:

appimageTools.wrapType2 (finalAttrs: {
  pname = "parsify";
  version = "2.0.1";

  src = fetchurl {
    url = "https://github.com/parsify-dev/desktop/releases/download/v${finalAttrs.version}/Parsify-${finalAttrs.version}-linux-x86_64.AppImage";
    hash = "sha256-ltWqRW+cBvuUJzhya62WsBY5zqIua9xhilxfd9gr24A=";
  };

  extraInstallCommands = ''
    install -m 444 -D ${finalAttrs.contents}/@parsifydesktop.desktop -t $out/share/applications

    substituteInPlace $out/share/applications/@parsifydesktop.desktop \
      --replace "Exec=AppRun" "Exec=parsify"

    cp -r ${finalAttrs.contents}/usr/share/* $out/share
  '';

  meta = {
    description = "Next generation notepad-based calculator, built with extendibility and privacy in mind";
    homepage = "https://parsify.app/";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ kashw2 ];
    platforms = lib.platforms.linux;
    mainProgram = "parsify";
  };
})
