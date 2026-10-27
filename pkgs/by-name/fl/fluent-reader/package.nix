{
  lib,
  fetchurl,
  appimageTools,
}:

appimageTools.wrapType2 (finalAttrs: {
  pname = "fluent-reader";
  version = "1.3.0";
  src = fetchurl {
    url = "https://github.com/yang991178/fluent-reader/releases/download/v${finalAttrs.version}/Fluent.Reader.${finalAttrs.version}.AppImage";
    hash = "sha256-glpe0zEpZ9+tcUSK2BI+AWAwcdt2RNQYnSDbGQV20eQ=";
  };

  extraInstallCommands = ''
    mkdir -p $out/share/${finalAttrs.pname}
    cp -a ${finalAttrs.contents}/{locales,resources} $out/share/${finalAttrs.pname}
    install -Dm 444 ${finalAttrs.contents}/${finalAttrs.pname}.desktop -t $out/share/applications
    cp -a ${finalAttrs.contents}/usr/share/icons $out/share/

    substituteInPlace $out/share/applications/${finalAttrs.pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=${finalAttrs.pname}'
  '';

  meta = {
    description = "Modern desktop RSS reader built with Electron, React, and Fluent UI";
    mainProgram = "fluent-reader";
    homepage = "https://hyliu.me/fluent-reader";
    license = lib.licenses.bsd3;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ zendo ];
  };
})
