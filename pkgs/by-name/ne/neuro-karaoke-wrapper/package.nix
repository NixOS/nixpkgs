{
  lib,
  appimageTools,
  fetchurl,
}:
let
  pname = "neuro-karaoke-wrapper";
  version = "1.8.1";
  src = fetchurl {
    url = "https://github.com/AferilVT/neuro-karaoke-wrapper/releases/download/v${version}/Neuro.Karaoke.Player-x86_64.AppImage";
    hash = "sha256-2iZdZq2XkK2jlVsg1i23+9IHyV5QPNl1bxL33qk/s+E=";
  };
  appimageContents = appimageTools.extractType2 {
    inherit pname version src;
  };
in
appimageTools.wrapType2 rec {
  inherit pname version src;
  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/neuro-karaoke-player.desktop $out/share/applications/${pname}.desktop

    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace-fail 'Exec=AppRun --no-sandbox %U' 'Exec=${pname} %U' \
      --replace-fail 'Icon=neuro-karaoke-player' 'Icon=${pname}'

    install -m 444 -D ${appimageContents}/neuro-karaoke-player.png $out/share/pixmaps/${pname}.png
  '';
  meta = {
    description = "Neuro Karaoke Player";
    homepage = "https://github.com/AferilVT/neuro-karaoke-wrapper";
    changelog = "https://github.com/AferilVT/neuro-karaoke-wrapper/releases/tag/v${version}";
    license = lib.licenses.gpl3;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    maintainers = [ lib.maintainers.semka612 ];
    platforms = [ "x86_64-linux" ];
    mainProgram = pname;
  };
}
