{
  lib,
  fetchurl,
  appimageTools,
}:

let
  pname = "raven-reader";
  version = "1.0.80";
  src = fetchurl {
    url = "https://github.com/hello-efficiency-inc/raven-reader/releases/download/v${version}/Raven-Reader-${version}.AppImage";
    sha256 = "sha256-RkpUWM1hAH73ePpQPj2C3SOukLpcPXbaXmb1VbcHaSU=";
  };
  appimageContents = appimageTools.extractType2 { inherit pname version src; };

in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    mkdir -p $out/share/${pname}
    cp -a ${appimageContents}/locales $out/share/${pname}
    cp -a ${appimageContents}/resources $out/share/${pname}

    install -m 444 -D ${appimageContents}/raven-reader.desktop -t $out/share/applications

    cp -a ${appimageContents}/usr/share/icons $out/share/

    substituteInPlace $out/share/applications/raven-reader.desktop \
      --replace 'Exec=AppRun' 'Exec=raven-reader'
  '';

  meta = with lib; {
    description = "Open source desktop news reader with flexible settings to optimize your experience";
    mainProgram = "raven-reader";
    homepage = "https://ravenreader.app/";
    license = licenses.mit;
    maintainers = with maintainers; [ wolfangaukang ];
    platforms = [ "x86_64-linux" ];
  };
}
