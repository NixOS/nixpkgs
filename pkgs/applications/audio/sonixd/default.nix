{ lib
, fetchurl
, appimageTools
}:

let
  pname = "sonixd";
  version = "0.15.3";
  src = fetchurl {
    url = "https://github.com/jeffvli/sonixd/releases/download/v${version}/Sonixd-${version}-linux-x86_64.AppImage";
    sha256 = "sha256-+4L3XAuR7T/z5a58SXre6yUiVi7TvSAs8vPgEC7hcIw=";
  };
  appimageContents = appimageTools.extractType2 { inherit pname version src; };
in
appimageTools.wrapType2 rec {
  inherit pname version src;

  extraInstallCommands = ''
    mv $out/bin/${pname}-${version} $out/bin/${pname}

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
  };
}

