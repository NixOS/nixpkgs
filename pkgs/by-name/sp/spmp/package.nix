{ lib
, appimageTools
, fetchurl
, imagemagick
}:

let
  pname = "spmp";
  version = "0.3.2";
  src = fetchurl {
    url = "https://github.com/toasterofbread/spmp/releases/download/v${version}/spmp-v${version}-linux-x86_64.appimage";
    hash = "sha256-QjcL/bEcWbeXGnRlU1RbUiIMI5VZFBoSTYlXpGznoxI=";
  };

  appimageContents = appimageTools.extractType2 {
    inherit pname version src;
  };
in
appimageTools.wrapType2 rec {
  inherit pname version src;
  extraPkgs = pkgs: with pkgs; [
    mpv
    libxcrypt-legacy
    zulu
    curl
    libappindicator-gtk3
    libdbusmenu
  ];

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/${pname}.desktop $out/share/applications/${pname}.desktop
    install -m 444 -D ${appimageContents}/${pname}.png $out/share/icons/hicolor/1024x1024/apps/${pname}.png

    ${imagemagick}/bin/magick ${appimageContents}/${pname}.png -resize 512x512 ${pname}_512.png
    install -m 444 -D ${pname}_512.png $out/share/icons/hicolor/512x512/apps/${pname}.png

    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace-fail 'Exec=bin/${pname}' 'Exec=${pname}'
  '';

  meta = {
    description = "YouTube Music client with a focus on customisation of colours and song metadata";
    homepage = "https://github.com/toasterofbread/spmp";
    changelog = "https://github.com/toasterofbread/spmp/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    platforms = [ "x86_64-linux" ];
    mainProgram = "spmp";
    maintainers = with lib.maintainers; [ spl3g ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
