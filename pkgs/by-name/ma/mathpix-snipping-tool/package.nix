{
  appimageTools,
  lib,
  fetchurl,
}:
let
  pname = "mathpix-snipping-tool";
  version = "03.00.0138";

  src = fetchurl {
    url = "https://download.mathpix.com/linux/Mathpix_Snipping_Tool-x86_64.v${version}.AppImage";
    sha256 = "sha256-29iLdrWxqLL7uRfHae8Mq+w9yaGtM9Y5vRLzYESgzBs=";
  };

  appimageContents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/${pname}.desktop -t $out/share/applications

    cp -r ${appimageContents}/usr/share/icons $out/share
  '';

  meta = with lib; {
    description = "OCR tool to convert pictures to LaTeX";
    homepage = "https://mathpix.com/";
    license = licenses.unfree;
    maintainers = [ maintainers.hiro98 ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "mathpix-snipping-tool";
  };
}
