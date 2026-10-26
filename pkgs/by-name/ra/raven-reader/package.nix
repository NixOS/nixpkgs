{
  lib,
  fetchurl,
  appimageTools,
}:

appimageTools.wrapType2 (finalAttrs: {
  pname = "raven-reader";
  version = "1.0.80";
  src = fetchurl {
    url = "https://github.com/hello-efficiency-inc/raven-reader/releases/download/v${finalAttrs.version}/Raven-Reader-${finalAttrs.version}.AppImage";
    sha256 = "sha256-RkpUWM1hAH73ePpQPj2C3SOukLpcPXbaXmb1VbcHaSU=";
  };

  extraInstallCommands = ''
    mkdir -p $out/share/${finalAttrs.pname}
    cp -a ${finalAttrs.contents}/locales $out/share/${finalAttrs.pname}
    cp -a ${finalAttrs.contents}/resources $out/share/${finalAttrs.pname}

    install -m 444 -D ${finalAttrs.contents}/raven-reader.desktop -t $out/share/applications

    cp -a ${finalAttrs.contents}/usr/share/icons $out/share/

    substituteInPlace $out/share/applications/raven-reader.desktop \
      --replace 'Exec=AppRun' 'Exec=raven-reader'
  '';

  meta = {
    description = "Open source desktop news reader with flexible settings to optimize your experience";
    mainProgram = "raven-reader";
    homepage = "https://ravenreader.app/";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = [ "x86_64-linux" ];
  };
})
