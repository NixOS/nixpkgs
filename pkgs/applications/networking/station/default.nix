{ appimageTools, fetchurl, lib }:

let
  pname = "station";
  version = "1.52.2";

  src = fetchurl {
    url = "https://github.com/getstation/desktop-app-releases/releases/download/${version}/Station-${version}-x86_64.AppImage";
    sha256 = "0lhiwvnf94is9klvzrqv2wri53gj8nms9lg2678bs4y58pvjxwid";
  };

  appimageContents = appimageTools.extractType2 {
    inherit pname version src;
  };
in appimageTools.wrapType2 rec {
  inherit pname version src;

  profile = ''
    export LC_ALL=C.UTF-8
  '';

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/browserx.desktop $out/share/applications/browserx.desktop
    install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/512x512/apps/browserx.png \
      $out/share/icons/hicolor/512x512/apps/browserx.png
    substituteInPlace $out/share/applications/browserx.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
  '';

  meta = with lib; {
    description = "Single place for all of your web applications";
    homepage = "https://getstation.com";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ ];
    mainProgram = "station";
  };
}
