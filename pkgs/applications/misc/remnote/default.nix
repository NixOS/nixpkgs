{
  lib,
  fetchurl,
  appimageTools,
}:
let
  pname = "remnote";
  version = "1.16.18";
  src = fetchurl {
    url = "https://download2.remnote.io/remnote-desktop2/RemNote-${version}.AppImage";
    hash = "sha256-ps7Rl1oA2QOPvO2XeCY8DrWtCV9WPlX9jbhypz2ZARA=";
  };
  appimageContents = appimageTools.extractType2 { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -Dm444 ${appimageContents}/remnote.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/remnote.desktop \
      --replace-fail 'Exec=AppRun --no-sandbox %U' 'Exec=remnote %u'
    install -Dm444 ${appimageContents}/remnote.png -t $out/share/pixmaps
  '';

  meta = with lib; {
    description = "Note-taking application focused on learning and productivity";
    homepage = "https://remnote.com/";
    maintainers = with maintainers; [ max-niederman chewblacka ];
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    mainProgram = "remnote";
  };
}
