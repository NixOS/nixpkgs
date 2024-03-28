{ appimageTools
, fetchurl
, lib
,
}:
let
  pname = "sigma-file-manager";
  version = "1.7.0";
  src = fetchurl {
    url = "https://github.com/aleksey-hoffman/sigma-file-manager/releases/download/v${version}/Sigma-File-Manager-${version}-Linux-Debian.AppImage";
    hash = "sha256-UZK45HvPrnomdhQe76ntKWNuF+fkyOCVhU4WAyjMxY4=";
  };
  appimageContents = appimageTools.extractType2 { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''

      # Installs .desktop files
      install -Dm444 ${appimageContents}/${pname}.desktop -t $out/share/applications
      install -Dm444 ${appimageContents}/${pname}.png -t $out/share/pixmaps
      substituteInPlace $out/share/applications/${pname}.desktop \
        --replace 'Exec=AppRun --no-sandbox %U' 'Exec=${pname}'
    '';

  meta = with lib; {
    description = "An open-source, quickly evolving, modern file manager (explorer / finder) app";
    homepage = "https://github.com/aleksey-hoffman/sigma-file-manager";
    platforms = [ "x86_64-linux" ];
    license = licenses.agpl3Plus;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ heisfer ];
    mainProgram = "sigma-file-manager";
  };
}
