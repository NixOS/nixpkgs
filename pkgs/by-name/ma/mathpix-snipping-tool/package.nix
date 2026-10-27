{
  appimageTools,
  lib,
  fetchurl,
  makeWrapper,
}:
appimageTools.wrapType2 (finalAttrs: {
  pname = "mathpix-snipping-tool";
  version = "03.00.0138";
  src = fetchurl {
    url = "https://download.mathpix.com/linux/Mathpix_Snipping_Tool-x86_64.v${finalAttrs.version}.AppImage";
    sha256 = "sha256-29iLdrWxqLL7uRfHae8Mq+w9yaGtM9Y5vRLzYESgzBs=";
  };

  nativeBuildInputs = [ makeWrapper ];

  extraInstallCommands = ''
    install -m 444 -D ${finalAttrs.contents}/${finalAttrs.pname}.desktop -t $out/share/applications

    cp -r ${finalAttrs.contents}/usr/share/icons $out/share

    wrapProgram $out/bin/${finalAttrs.pname} --set QT_QPA_PLATFORM xcb
  '';

  meta = {
    description = "OCR tool to convert pictures to LaTeX";
    homepage = "https://mathpix.com/";
    license = lib.licenses.unfree;
    maintainers = [
      lib.maintainers.hiro98
      lib.maintainers.axodentally
    ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "mathpix-snipping-tool";
  };
})
