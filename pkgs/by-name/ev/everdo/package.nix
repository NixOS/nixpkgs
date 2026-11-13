{
  appimageTools,
  lib,
  fetchurl,
}:
appimageTools.wrapType2 (finalAttrs: {
  pname = "everdo";
  version = "1.11.9";
  src = fetchurl {
    url = "https://downloads.everdo.net/electron/Everdo-${finalAttrs.version}.AppImage";
    hash = "sha256-67b0gSoVcCIfkFRUL3afgB6eYj5YEuvDTtQgTIwV9S0=";
  };

  extraInstallCommands = ''
    install -Dm444 ${finalAttrs.contents}/everdo.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/everdo.desktop \
      --replace-fail 'Exec=AppRun --no-sandbox %U' 'Exec=everdo %u'
    cp -r ${finalAttrs.contents}/usr/share/icons $out/share
  '';

  meta = {
    description = "Cross-platform GTD app with focus on privacy";
    homepage = "https://everdo.net/";
    license = lib.licenses.unfree;
    maintainers = [ lib.maintainers.luftmensch-luftmensch ];
    mainProgram = "everdo";
    platforms = [ "x86_64-linux" ];
  };
})
