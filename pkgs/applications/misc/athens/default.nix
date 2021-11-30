{ lib, fetchurl, appimageTools }:

let
  pname = "athens";
  version = "2.0.0-beta.3";

  src = fetchurl {
    url = "https://github.com/athensresearch/athens/releases/download/v${version}/Athens-${version}.AppImage";
    name = "Athens-${version}.AppImage";
    sha256 = "sha256-2uw2ZGdUQLST+4fqDv/mrDKFuUhv543oZsDKkYFefrA=";
  };
  appimageContents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    mv $out/bin/${pname}-${version} $out/bin/${pname}
    install -m 444 -D ${appimageContents}/athens.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/athens.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
    install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/0x0/apps/athens.png \
      -t $out/share/icons/hicolor/512x512/apps
  '';

  meta = with lib; {
    description = "Open-source knowledge graph";
    homepage = "https://github.com/athensresearch/athens";
    license = licenses.epl10;
    maintainers = with maintainers; [ bbigras ];
    platforms = [ "x86_64-linux" ];
  };
}
