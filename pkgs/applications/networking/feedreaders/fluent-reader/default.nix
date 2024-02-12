{ lib, fetchurl, appimageTools }:

let
  pname = "fluent-reader";
  version = "1.1.4";

  src = fetchurl {
    url = "https://github.com/yang991178/fluent-reader/releases/download/v${version}/Fluent.Reader.${version}.AppImage";
    hash = "sha256-2oLV9SWBNt0j1WAS6j4dobsUEpptjTubpr8pdOcIOY4=";
  };

  appimageContents = appimageTools.extractType2 { inherit pname version src; };
in appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    mv $out/bin/${pname}-${version} $out/bin/${pname}

    mkdir -p $out/share/${pname}
    cp -a ${appimageContents}/{locales,resources} $out/share/${pname}
    install -Dm 444 ${appimageContents}/${pname}.desktop -t $out/share/applications
    cp -a ${appimageContents}/usr/share/icons $out/share/

    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
  '';

  meta = with lib; {
    description = "Modern desktop RSS reader built with Electron, React, and Fluent UI";
    homepage = "https://hyliu.me/fluent-reader";
    license = licenses.bsd3;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ zendo ];
  };
}
