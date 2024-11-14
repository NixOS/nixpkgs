{ lib
, fetchurl
, appimageTools
}:

let
  pname = "sonixd";
  version = "0.15.5";
  src = fetchurl {
    url = "https://github.com/jeffvli/sonixd/releases/download/v${version}/Sonixd-${version}-linux-x86_64.AppImage";
    sha256 = "sha256-j8B+o/CJ5SsZPMNbugyP3T9Kb+xuxlVxH02loxlwwDg=";
  };
  appimageContents = appimageTools.extractType2 { inherit pname version src; };
in
appimageTools.wrapType2 rec {
  inherit pname version src;

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/${pname}.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun --no-sandbox %U' 'Exec=${pname}'
    cp -r ${appimageContents}/usr/share/icons $out/share
  '';

  meta = with lib; {
    description = "Full-featured Subsonic/Jellyfin compatible desktop music player";
    homepage = "https://github.com/jeffvli/sonixd";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ onny ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "sonixd";
  };
}
