{ lib
, appimageTools
, fetchurl
}:

let
  pname = "open-goal-launcher";
  version = "2.4.0";

  src = fetchurl {
    url = "https://github.com/open-goal/launcher/releases/download/v${version}/open-goal-launcher_${version}_amd64.AppImage";
    sha256 = "sha256-aVzuf3Ml2a0jBCuDbdJnYRBNABTUhT/f3u1tNymVxXY=";
  };

  appimageContents = appimageTools.extract {
    inherit pname version src;
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    mv $out/bin/${pname}-${version} $out/bin/${pname}

    install -m 444 -D ${appimageContents}/usr/share/applications/${pname}.desktop -t $out/share/applications
    cp -r ${appimageContents}/usr/share/icons $out/share
  '';

  meta = with lib; {
    description = "A launcher for the OpenGOAL Project to simplify usage and installation";
    homepage = "https://github.com/open-goal/launcher";
    license = licenses.isc;
    maintainers = with maintainers; [ martfont ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "open-goal-launcher";
  };
}
