{
  appimageTools,
  lib,
  fetchurl,
}: let
  pname = "nuclear";
  version = "0.6.27";

  src = fetchurl {
    url = "https://github.com/nukeop/nuclear/releases/download/v${version}/${pname}-v${version}.AppImage";
    hash = "sha256-vCtGuId2yMVIQrMZcjN1i2buV4sah2qKupbr4LhqMbA=";
  };

  appimageContents = appimageTools.extract {inherit pname version src;};
in
  appimageTools.wrapType2 {
    inherit pname version src;

    extraInstallCommands = ''
      install -m 444 -D ${appimageContents}/${pname}.desktop -t $out/share/applications
      substituteInPlace $out/share/applications/${pname}.desktop \
        --replace 'Exec=AppRun' 'Exec=${pname}'
      cp -r ${appimageContents}/usr/share/icons $out/share
    '';

    meta = with lib; {
      description = "Streaming music player that finds free music for you";
      homepage = "https://nuclear.js.org/";
      license = licenses.agpl3Plus;
      maintainers = with maintainers; [NotAShelf ivar];
      platforms = ["x86_64-linux"];
    };
  }
