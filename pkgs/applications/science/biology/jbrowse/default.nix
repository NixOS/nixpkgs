{ lib, fetchurl, appimageTools, wrapGAppsHook }:

let
  pname = "jbrowse";
  version = "2.5.0";

  src = fetchurl {
    url = "https://github.com/GMOD/jbrowse-components/releases/download/v${version}/jbrowse-desktop-v${version}-linux.AppImage";
    sha256 = "sha256-YLsyA+RVoFvjE4MfAtglJYdUgic487SxwdUhvolzBPc=";
  };

  appimageContents = appimageTools.extractType2 {
    inherit pname version src;
  };

in
appimageTools.wrapType2 {
  inherit pname version src;
  unshareIpc = false;

  extraInstallCommands = ''
    mkdir -p $out/bin
    mv $out/bin/jbrowse-${version} $out/bin/jbrowse-desktop

    install -m 444 -D ${appimageContents}/jbrowse-desktop.desktop $out/share/applications/jbrowse-desktop.desktop
    install -m 444 -D ${appimageContents}/jbrowse-desktop.png \
       $out/share/icons/hicolor/512x512/apps/jbrowse-desktop.png
    substituteInPlace $out/share/applications/jbrowse-desktop.desktop \
      --replace 'Exec=AppRun --no-sandbox' 'Exec=jbrowse-desktop'
  '';

  meta = with lib; {
    description = "The next-generation genome browser";
    homepage = "https://jbrowse.org/jb2/";
    license = licenses.asl20;
    maintainers = with maintainers; [ benwbooth ];
    platforms = [ "x86_64-linux" ];
  };
}
