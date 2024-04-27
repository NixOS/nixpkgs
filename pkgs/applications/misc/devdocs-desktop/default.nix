{ lib, appimageTools, fetchurl }:

let
  version = "0.7.2";
  pname = "devdocs-desktop";

  src = fetchurl {
    url = "https://github.com/egoist/devdocs-desktop/releases/download/v${version}/DevDocs-${version}.AppImage";
    sha256 = "sha256-4ugpzh0Dweae6tKb6uqRhEW9HT+iVIo8MQRbVKTdRFw=";
  };

  appimageContents = appimageTools.extractType2 {
    inherit pname version src;
  };

in appimageTools.wrapType2 rec {
  inherit pname version src;

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/devdocs.desktop $out/share/applications/devdocs.desktop
    install -m 444 -D ${appimageContents}/devdocs.png $out/share/icons/hicolor/0x0/apps/devdocs.png
    substituteInPlace $out/share/applications/devdocs.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
  '';

  meta = with lib; {
    description = "A full-featured desktop app for DevDocs.io";
    longDescription = ''
      DevDocs.io combines multiple API documentations in a fast, organized, and searchable interface. This is an unofficial desktop app for it.
    '';
    homepage = "https://github.com/egoist/devdocs-desktop";
    downloadPage = "https://github.com/egoist/devdocs-desktop/releases";
    license = licenses.mit;
    maintainers = with maintainers; [ ymarkus ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "devdocs-desktop";
  };
}
