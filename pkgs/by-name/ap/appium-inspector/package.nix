{ appimageTools, fetchurl, lib }:

let
  pname = "appium-inspector";
  version = "2024.3.1";

  src = fetchurl {
    url = "https://github.com/appium/appium-inspector/releases/download/v${version}/Appium-Inspector-linux-${version}.AppImage";
    hash = "sha256-ua0Tnjp+evG5dwVIzHyG4eG3WQEMQLedZHLX7hxlWSo=";
  };

  appimageContents = appimageTools.extract {
    inherit pname version src;
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    mv $out/bin/${pname}-${version} $out/bin/${pname}
    install -m 444 -D ${appimageContents}/appium-inspector.desktop -t $out/share/applications/
    install -m 444 -D ${appimageContents}/appium-inspector.png -t $out/share/icons/hicolor/512x512/apps/
    substituteInPlace $out/share/applications/appium-inspector.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
  '';

  meta = with lib; {
    description = "A GUI inspector for mobile apps and more, powered by a (separately installed) Appium server";
    homepage = "https://github.com/appium/appium-inspector";
    changelog = "https://github.com/appium/appium-inspector/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ bprevor ];
    platforms = [ "x86_64-linux" ];
  };
}
