{
  lib,
  appimageTools,
  fetchurl,
}:

let
  pname = "codux";
  version = "15.27.0";

  src = fetchurl {
    url = "https://github.com/wixplosives/codux-versions/releases/download/${version}/Codux-${version}.x86_64.AppImage";
    sha256 = "sha256-FsTGBms98jZZP0QSJwjoGMyuK4Pgcpl1htrDSdp52lU=";
  };

  appimageContents = appimageTools.extractType2 { inherit pname version src; };
in

appimageTools.wrapType2 rec {
  inherit pname version src;

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/${pname}.desktop -t $out/share/applications
    cp -r ${appimageContents}/usr/share/icons $out/share
    substituteInPlace $out/share/applications/${pname}.desktop  --replace 'Exec=AppRun' 'Exec=${pname}'
  '';

  meta = with lib; {
    description = "A visual IDE for React";
    homepage = "https://www.codux.com";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [
      dit7ya
      kashw2
    ];
    mainProgram = "codux";
  };
}
