{
  lib,
  appimageTools,
  fetchurl,
}:

let
  pname = "gopanda2";
  version = "2.8.3";

  src = fetchurl {
    url = "https://pandanet-igs.com/gopanda2/download/GoPanda2-${version}.AppImage";
    hash = "sha256-bnAiQwpruEopYn9JPYxnI/fAGI6xeu7H9ZBbOyMg6ug=";
  };

  appimageContents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -Dm444 ${appimageContents}/gopanda2.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/gopanda2.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=gopanda2'
    cp -r ${appimageContents}/usr/share/icons $out/share
  '';

  meta = {
    description = "Client for the Pandanet-IGS Go server";
    homepage = "https://pandanet-igs.com/communities/gopanda2";
    license = lib.licenses.unfreeRedistributable;
    mainProgram = "gopanda2";
    maintainers = with lib.maintainers; [ chessai ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
