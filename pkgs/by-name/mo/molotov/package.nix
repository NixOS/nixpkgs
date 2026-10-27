{
  appimageTools,
  lib,
  fetchurl,
}:

appimageTools.wrapType2 (finalAttrs: {
  pname = "molotov";
  version = "4.4.0";
  src = fetchurl {
    url = "https://desktop-auto-upgrade.molotov.tv/linux/${finalAttrs.version}/molotov.AppImage";
    sha256 = "sha256-l4Il6i8uXSeJqH3ITC8ZUpKXPQb0qcW7SpKx1R46XDc=";
  };

  extraInstallCommands = ''
    install -m 444 -D \
      ${finalAttrs.contents}/@molotovdesktop-wrapper.desktop \
      $out/share/applications/${finalAttrs.pname}.desktop
    substituteInPlace $out/share/applications/${finalAttrs.pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=${finalAttrs.pname}'
    cp -r ${finalAttrs.contents}/usr/share/icons $out/share
  '';
  meta = {
    description = "French TV service";
    homepage = "https://www.molotov.tv/";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ apeyroux ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "molotov";
  };
})
