{
  appimageTools,
  fetchurl,
  lib,
}:

let
  pname = "irccloud";
  version = "0.16.0";

  src = fetchurl {
    url = "https://github.com/irccloud/irccloud-desktop/releases/download/v${version}/IRCCloud-${version}-linux-x86_64.AppImage";
    sha256 = "sha256-/hMPvYdnVB1XjKgU2v47HnVvW4+uC3rhRjbucqin4iI=";
  };

  appimageContents = appimageTools.extractType2 {
    inherit pname version src;
  };

in
appimageTools.wrapType2 {
  inherit pname version src;

  extraPkgs = pkgs: [ pkgs.at-spi2-core ];

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/irccloud.desktop $out/share/applications/irccloud.desktop
    install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/512x512/apps/irccloud.png \
      $out/share/icons/hicolor/512x512/apps/irccloud.png
    substituteInPlace $out/share/applications/irccloud.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
  '';

  meta = with lib; {
    description = "Desktop client for IRCCloud";
    mainProgram = "irccloud";
    homepage = "https://www.irccloud.com";
    license = licenses.asl20;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ lightbulbjim ];
  };
}
