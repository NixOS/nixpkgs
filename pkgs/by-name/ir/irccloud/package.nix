{
  appimageTools,
  fetchurl,
  lib,
}:

appimageTools.wrapType2 (finalAttrs: {
  pname = "irccloud";
  version = "0.16.0";
  src = fetchurl {
    url = "https://github.com/irccloud/irccloud-desktop/releases/download/v${finalAttrs.version}/IRCCloud-${finalAttrs.version}-linux-x86_64.AppImage";
    sha256 = "sha256-/hMPvYdnVB1XjKgU2v47HnVvW4+uC3rhRjbucqin4iI=";
  };

  extraPkgs = pkgs: [ pkgs.at-spi2-core ];

  extraInstallCommands = ''
    install -m 444 -D ${finalAttrs.contents}/irccloud.desktop $out/share/applications/irccloud.desktop
    install -m 444 -D ${finalAttrs.contents}/usr/share/icons/hicolor/512x512/apps/irccloud.png \
      $out/share/icons/hicolor/512x512/apps/irccloud.png
    substituteInPlace $out/share/applications/irccloud.desktop \
      --replace 'Exec=AppRun' 'Exec=${finalAttrs.pname}'
  '';

  meta = {
    description = "Desktop client for IRCCloud";
    mainProgram = "irccloud";
    homepage = "https://www.irccloud.com";
    license = lib.licenses.asl20;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ lightbulbjim ];
  };
})
