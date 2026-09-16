{
  lib,
  fetchurl,
  appimageTools,
  makeWrapper,
}:

appimageTools.wrapType2 rec {
  pname = "kdrive";
  version = "3.8.7.1";

  src = fetchurl {
    url = "https://download.storage.infomaniak.com/drive/desktopclient/kDrive-${version}-amd64.AppImage";
    name = "kdrive-${version}.AppImage";
    hash = "sha256-jWV/D6WKBj4xXtZ2tBaLINMEcKpcy0FgrlsF+hqqQ3o=";
  };

  nativeBuildInputs = [ makeWrapper ];

  extraInstallCommands =
    let
      contents = appimageTools.extract { inherit pname version src; };
    in
    ''
      wrapProgram $out/bin/kdrive \
        --set APPIMAGE "${src}"

      install -m 444 -D \
        ${contents}/usr/share/applications/kDrive_client.desktop \
        $out/share/applications/kDrive_client.desktop

      install -m 444 -D \
        ${contents}/usr/share/icons/hicolor/64x64/apps/kdrive-win.png \
        $out/share/icons/hicolor/64x64/apps/kdrive-win.png

      substituteInPlace $out/share/applications/kDrive_client.desktop \
        --replace-fail 'Exec=kDrive' 'Exec=kdrive'
    '';

  meta = {
    description = "kDrive desktop synchronization client";
    homepage = "https://www.infomaniak.com/en/apps/download-kdrive";
    license = lib.licenses.unfree;
    maintainers = [ lib.maintainers.gaetinux ];
    mainProgram = "kdrive";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
