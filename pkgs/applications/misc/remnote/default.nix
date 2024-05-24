{
  lib,
  fetchurl,
  appimageTools,
}:
let
  pname = "remnote";
  version = "1.16.4";
  src = fetchurl {
    url = "https://download.remnote.io/remnote-desktop/RemNote-${version}.AppImage";
    hash = "sha256-dgbQ0cbPq7BSQ9VwwH6+GoAxb85HDxRixfjeDJBtOrg=";
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
    description = "A note-taking application focused on learning and productivity";
    homepage = "https://remnote.com/";
    maintainers = with maintainers; [ max-niederman chewblacka ];
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    mainProgram = "remnote";
  };
}
