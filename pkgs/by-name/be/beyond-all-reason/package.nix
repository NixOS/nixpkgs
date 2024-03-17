{ lib, appimageTools, fetchurl, openal }:

appimageTools.wrapType2 rec {
  name = "beyond-all-reason";
  version = "1.2988.0";

  src = fetchurl {
    url = "https://github.com/beyond-all-reason/BYAR-Chobby/releases/download/v${version}/Beyond-All-Reason-${version}.AppImage";
    sha256 = "sha256-ZJW5BdxxqyrM2TJTO0SBp4BXt3ILyi77EZx73X8hqJE=";
  };

  extraInstallCommands = let
    appimageContents = appimageTools.extract { inherit name src; };
    in ''
      install -m 444 -D ${appimageContents}/${name}.desktop -t $out/share/applications
      substituteInPlace $out/share/applications/${name}.desktop \
        --replace 'Exec=AppRun' 'Exec=${name}'
      cp -r ${appimageContents}/usr/share/icons $out/share
    '';
  extraPkgs = pkgs: [ openal ];
  meta = with lib; {
    description = "Open source RTS game built on top of the Spring RTS Engine";
    homepage = "https://github.com/beyond-all-reason/beyond-all-reason";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ tgunnoe ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "beyond-all-reason";
  };
}
