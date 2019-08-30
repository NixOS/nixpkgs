{ appimageTools, fetchurl, lib }:

let
  pname = "irccloud";
  version = "0.13.0";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://github.com/irccloud/irccloud-desktop/releases/download/v${version}/IRCCloud-${version}-linux-x86_64.AppImage";
    sha256 = "0ff69m5jav2c90918avsr5wvik2gds3klij3dzhkb352fgrd1s0l";
  };

  appimageContents = appimageTools.extractType2 {
    inherit name src;
  };

in appimageTools.wrapType2 rec {
  inherit name src;

  extraPkgs = pkgs: with pkgs; [ at-spi2-core ];

  extraInstallCommands = ''
    mv $out/bin/${name} $out/bin/${pname}
    install -m 444 -D ${appimageContents}/irccloud.desktop $out/share/applications/irccloud.desktop
    install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/512x512/apps/irccloud.png \
      $out/share/icons/hicolor/512x512/apps/irccloud.png
    substituteInPlace $out/share/applications/irccloud.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
  '';

  meta = with lib; {
    description = "A desktop client for IRCCloud";
    homepage = "https://www.irccloud.com";
    license = licenses.asl20;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ lightbulbjim ];
  };
}
