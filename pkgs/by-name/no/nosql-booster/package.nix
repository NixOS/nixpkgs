{
  lib,
  platforms,
  appimageTools,
  fetchurl,
}:
let
  pname = "nosql-booster";
  version = "8.1.9";
  src = fetchurl {
    url = "https://s3.nosqlbooster.com/download/releasesv8/nosqlbooster4mongo-${version}.AppImage";
    sha256 = "sha256-ZJdCHOodJel7Apb//s96vrf1Ruml/NLUMQ9eFFR9tfU=";
  };
  meta = {
    homepage = "https://nosqlbooster.com/";
    description = "GUI tool for MongoDB Server";
    changelog = "https://nosqlbooster.com/blog/announcing-nosqlbooster-81/#version-819";
    maintainers = with lib.maintainers; [ guillaumematheron ];
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    mainProgram = "nosql-booster";
  };

  appimageContents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit
    pname
    version
    src
    meta
    ;

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/nosqlbooster4mongo.desktop $out/share/applications/nosqlbooster4mongo.desktop
    install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/512x512/apps/nosqlbooster4mongo.png \
      $out/share/icons/hicolor/512x512/apps/nosqlbooster4mongo.png
    substituteInPlace $out/share/applications/nosqlbooster4mongo.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=${meta.mainProgram}'
  '';
}
