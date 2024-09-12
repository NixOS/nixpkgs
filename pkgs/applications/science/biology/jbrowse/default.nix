{ lib, fetchurl, appimageTools }:

let
  pname = "jbrowse";
  version = "2.15.0";

  src = fetchurl {
    url = "https://github.com/GMOD/jbrowse-components/releases/download/v${version}/jbrowse-desktop-v${version}-linux.AppImage";
    sha256 = "sha256-WA0R1V83xlUFSDR4B95BX7VpzLUVF4U7f+t+x+lt30o=";
  };

  appimageContents = appimageTools.extractType2 {
    inherit pname version src;
  };

in
appimageTools.wrapType2 {
  inherit pname version src;
  unshareIpc = false;

  extraInstallCommands = ''
    mv $out/bin/jbrowse $out/bin/jbrowse-desktop
    install -m 444 -D ${appimageContents}/jbrowse-desktop.desktop $out/share/applications/jbrowse-desktop.desktop
    install -m 444 -D ${appimageContents}/jbrowse-desktop.png \
       $out/share/icons/hicolor/512x512/apps/jbrowse-desktop.png
    substituteInPlace $out/share/applications/jbrowse-desktop.desktop \
      --replace 'Exec=AppRun --no-sandbox' 'Exec=jbrowse-desktop'
  '';

  meta = with lib; {
    description = "Next-generation genome browser";
    mainProgram = "jbrowse-desktop";
    homepage = "https://jbrowse.org/jb2/";
    license = licenses.asl20;
    maintainers = with maintainers; [ benwbooth ];
    platforms = [ "x86_64-linux" ];
  };
}
