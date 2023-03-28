{ lib, appimageTools, fetchurl }:

let
  pname = "curo-ui";
  version = "6.3.23";

  src = fetchurl {
    url = "https://dl.curo.sk/curoapp/${pname}-x86_64.AppImage";
    sha256 = "1wkxck4ssblx4dp3hningrr4gkzn947321w2m8wx3173n5vmdhmg";
  };

  appimageContents = appimageTools.extractType2 {
    inherit pname version src;
  };

in 
appimageTools.wrapType2 {
  inherit pname version src;
  
  extraInstallCommands = ''
    mv $out/bin/${pname}-${version} $out/bin/${pname}
    install -m 444 -D ${appimageContents}/curo.desktop $out/share/applications/curo.desktop
    install -m 444 -D ${appimageContents}/curo.png $out/share/icons/hicolor/512x512/apps/curo.png
    substituteInPlace $out/share/applications/curo.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
  '';

  meta = with lib; {
    description = "Healthcare information system Curo.";
    longDescription = ''
      Curo UI is a healthcare information system designed for the needs of healthcare facilities. Obtain an additional assistant at your clinic. Less administration when managing your clinic. Curo is appreciated by doctors and nurses alike. Curo helps you focus on patients and their treatment.
    '';
    homepage = "https://www.curo.sk/";
    downloadPage = "https://www.curo.sk/l/ui";
    maintainers = with maintainers; [ sotommi ];
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
  };
}
