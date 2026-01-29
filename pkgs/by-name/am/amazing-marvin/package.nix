{
  appimageTools,
  fetchurl,
  lib,
}:

let
  pname = "amazing-marvin";
  version = "1.68.0";

  src = fetchurl {
    url = "https://amazingmarvin.s3.amazonaws.com/Marvin-${version}.AppImage";
    hash = "sha256-c6ql3loog0nU7dcCHe5ba7PEhcyQ+MwTTIAKKT5aOB4=";
  };

  appimageContents = appimageTools.extract { inherit pname version src; };

in
appimageTools.wrapType2 {
  inherit pname version src;
  extraInstallCommands = ''
    install -Dm 444 ${appimageContents}/marvin.desktop -t $out/share/applications
    install -Dm 444 ${appimageContents}/usr/share/icons/hicolor/512x512/apps/marvin.png \
      -t $out/share/icons/hicolor/512x512/apps/
    substituteInPlace $out/share/applications/marvin.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=amazing-marvin'
  '';

  meta = {
    description = "Desktop client for Amazing Marvin";
    homepage = "https://amazingmarvin.com/";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ otisdog8 ];
    mainProgram = "amazing-marvin";
    platforms = [ "x86_64-linux" ];
  };
}
