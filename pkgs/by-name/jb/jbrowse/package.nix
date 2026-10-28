{
  lib,
  fetchurl,
  appimageTools,
}:

appimageTools.wrapType2 (finalAttrs: {
  pname = "jbrowse";
  version = "4.3.0";
  src = fetchurl {
    url = "https://github.com/GMOD/jbrowse-components/releases/download/v${finalAttrs.version}/jbrowse-desktop-v${finalAttrs.version}-linux.AppImage";
    sha256 = "sha256-8d/nF2e92BLYzlw7MfLon+dWZnwnoIFCLy+gTGA1E14=";
  };

  unshareIpc = false;

  extraInstallCommands = ''
    mv $out/bin/jbrowse $out/bin/jbrowse-desktop
    install -m 444 -D ${finalAttrs.contents}/jbrowse-desktop.desktop $out/share/applications/jbrowse-desktop.desktop
    install -m 444 -D ${finalAttrs.contents}/jbrowse-desktop.png \
       $out/share/icons/hicolor/512x512/apps/jbrowse-desktop.png
    substituteInPlace $out/share/applications/jbrowse-desktop.desktop \
      --replace 'Exec=AppRun --no-sandbox' 'Exec=jbrowse-desktop'
  '';

  meta = {
    description = "Next-generation genome browser";
    mainProgram = "jbrowse-desktop";
    homepage = "https://jbrowse.org/jb2/";
    license = lib.licenses.asl20;
    maintainers = [ ];
    platforms = [ "x86_64-linux" ];
  };
})
