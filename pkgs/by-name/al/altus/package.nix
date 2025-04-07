{
  lib,
  fetchurl,
  appimageTools,
  makeWrapper,
}:

let
  pname = "altus";
  version = "5.6.1";

  src = fetchurl {
    name = "altus-${version}.AppImage";
    url = "https://github.com/amanharwara/altus/releases/download/${version}/Altus-${version}.AppImage";
    hash = "sha512-wkH9ZEmEJTP8PAPBG4QeewGrR2Nmd4p2ZWTP/il4+bHREz0N8GttUwkjhYOy1heRSV/S+zlkGjfB8VTaNjGaaA==";
  };

  appimageContents = appimageTools.extractType2 {
    inherit pname version src;
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  nativeBuildInputs = [ makeWrapper ];

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/Altus.desktop $out/share/applications/altus.desktop
    install -m 444 -D ${appimageContents}/Altus.png \
      $out/share/icons/hicolor/scalable/apps/altus.png
    substituteInPlace $out/share/applications/altus.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=altus'
    wrapProgram "$out/bin/altus" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"
  '';

  meta = {
    description = "Client for WhatsApp Web with themes, notifications and multiple accounts support";
    homepage = "https://github.com/amanharwara/altus";
    changelog = "https://github.com/amanharwara/altus/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ johnrtitor ];
    platforms = [ "x86_64-linux" ];
  };
}
