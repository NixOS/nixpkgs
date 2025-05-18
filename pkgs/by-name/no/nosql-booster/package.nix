{
  lib,
  platforms,
  appimageTools,
  fetchurl,
}:
let
  pname = "nosql-booster";
  version = "10.0.0";
  src = fetchurl {
    url = "https://s3.nosqlbooster.com/download/releasesv${lib.versions.major version}/nosqlbooster4mongo-${version}.AppImage";
    hash = "sha256-HjQgcg7tG8J7bizvEy32N3/e6ybBQO0XISUdCuGi6SM=";
  };
  meta = {
    homepage = "https://nosqlbooster.com/";
    description = "GUI tool for MongoDB Server";
    changelog = "https://nosqlbooster.com/blog/announcing-nosqlbooster-10";
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
