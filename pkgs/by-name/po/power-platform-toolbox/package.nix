{
  lib,
  appimageTools,
  fetchurl,
  makeWrapper,
}:

let
  pname = "power-platform-toolbox";
  version = "1.2.2";

  src = fetchurl {
    url = "https://github.com/PowerPlatformToolBox/desktop-app/releases/download/v${version}/Power-Platform-ToolBox-${version}-x86_64-linux.AppImage";
    hash = "sha256-Pgf6JqBmTSsThhqJZ0KC8UNuSj77s+mT2cYlVaevr+4=";
  };

  appimageContents = appimageTools.extractType1 {
    inherit pname version src;
  };
in
(appimageTools.wrapType2 {
  inherit pname version src;

  nativeBuildInputs = [ makeWrapper ];

  extraInstallCommands = ''
    install -Dm444 ${appimageContents}/powerplatform-toolbox.desktop -T $out/share/applications/${pname}.desktop
    install -Dm444 ${appimageContents}/powerplatform-toolbox.png -T $out/share/icons/hicolor/512x512/apps/${pname}.png

    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace-fail 'Exec=AppRun' "Exec=${pname}" \
      --replace-fail 'Icon=powerplatform-toolbox' "Icon=${pname}"

    wrapProgram $out/bin/${pname} \
      --set ELECTRON_OZONE_PLATFORM_HINT x11
  '';

  meta = {
    description = "Desktop app for managing Microsoft Power Platform resources";
    homepage = "https://www.powerplatformtoolbox.com";
    downloadPage = "https://github.com/PowerPlatformToolBox/desktop-app/releases";
    license = lib.licenses.gpl3Only;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    maintainers = with lib.maintainers; [ mbwilding ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "power-platform-toolbox";
  };
}).overrideAttrs
  {
    strictDeps = true;
    __structuredAttrs = true;
  }
