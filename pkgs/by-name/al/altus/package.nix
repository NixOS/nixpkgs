{
  lib,
  fetchurl,
  appimageTools,
  makeWrapper,
}:

let
  pname = "altus";
  version = "5.7.1";

  src = fetchurl {
    name = "altus-${version}.AppImage";
    url = "https://github.com/amanharwara/altus/releases/download/${version}/Altus-${version}.AppImage";
    hash = "sha256-G0jKBnobMKJWZmLtyYLpdruNxEVGt5rZHPFJYJkY8Y4=";
  };

  appimageContents = appimageTools.extractType2 {
    inherit pname version src;
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  nativeBuildInputs = [ makeWrapper ];

  extraInstallCommands = ''
    install -Dm 644 ${appimageContents}/Altus.desktop -t $out/share/applications
    install -Dm 644 ${appimageContents}/Altus.png -t $out/share/icons/hicolor/256x256/apps
    substituteInPlace $out/share/applications/Altus.desktop \
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
