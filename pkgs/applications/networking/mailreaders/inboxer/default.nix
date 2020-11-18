{ stdenv, fetchurl, appimageTools }:

let
  pname = "inboxer";
  version = "1.3.2";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://github.com/denysdovhan/inboxer/releases/download/v${version}/inboxer-${version}-x86_64.AppImage";
    sha256 = "110c4g4c18j9hlp31acr9nardr2isrq3lbi2a10l2kf1ngxh7cc6";
  };

  appimageContents = appimageTools.extractType2 {
    inherit name src;
  };

in appimageTools.wrapType2 {
  inherit name src;

  extraInstallCommands = ''
    # fix the path in the desktop file
    mv $out/bin/${name} $out/bin/${pname}
    install -m 444 -D ${appimageContents}/inboxer.desktop $out/share/applications/inboxer.desktop
    install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/512x512/apps/inboxer.png \
      $out/share/icons/hicolor/512x512/apps/inboxer.png
    substituteInPlace \
      $out/share/applications/inboxer.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
  '';

   meta = with stdenv.lib; {
    description = "Unofficial, free and open-source Google Inbox Desktop App";
    homepage    = "https://denysdovhan.com/inboxer";
    maintainers = [ maintainers.mgttlinger ];
    license     = licenses.mit;
    platforms   = [ "x86_64-linux" ];
  };
}
