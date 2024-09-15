{ lib
, appimageTools
, fetchurl
}:

let
  pname = "jan";
  version = "0.5.3";
  src = fetchurl {
    url = "https://github.com/janhq/jan/releases/download/v${version}/jan-linux-x86_64-${version}.AppImage";
    hash = "sha256-lfN5ant3oS7uschxyCxmiKNLJUJiqWVZLaJ8djqNKzQ=";
  };

  appimageContents = appimageTools.extractType2 { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -Dm444 ${appimageContents}/jan.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/jan.desktop \
      --replace-fail 'Exec=AppRun --no-sandbox %U' 'Exec=jan'
    cp -r ${appimageContents}/usr/share/icons $out/share
  '';

  meta = {
    changelog = "https://github.com/janhq/jan/releases/tag/v${version}";
    description = "Jan is an open source alternative to ChatGPT that runs 100% offline on your computer";
    homepage = "https://github.com/janhq/jan";
    license = lib.licenses.agpl3Plus;
    mainProgram = "jan";
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
}
