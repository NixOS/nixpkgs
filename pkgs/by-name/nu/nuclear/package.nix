{
  appimageTools,
  lib,
  fetchurl,
}:
let
  pname = "nuclear";
  version = "0.6.31";

  src = fetchurl {
    # Nuclear currenntly only publishes AppImage releases for x86_64, which is hardcoded in
    # the package name. We also hardcode the host arch in the release name, but should upstream
    # provide more arches, we should use stdenv.hostPlatform to determine the arch and choose
    # source URL accordingly.
    url = "https://github.com/nukeop/nuclear/releases/download/v${version}/${pname}-v${version}-x86_64.AppImage";
    hash = "sha256-ezho69fDP4OiLpC8KNKc8OIZ++TX4GUinFB6o8MLx3I=";
  };

  appimageContents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/${pname}.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=${pname}'
    cp -r ${appimageContents}/usr/share/icons $out/share
  '';

  meta = {
    description = "Streaming music player that finds free music for you";
    homepage = "https://nuclear.js.org/";
    license = lib.licenses.agpl3Plus;
    maintainers = [ lib.maintainers.NotAShelf ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "nuclear";
  };
}
