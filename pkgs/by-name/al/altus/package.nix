{
  lib,
  fetchurl,
  appimageTools,
  makeWrapper,
}:

appimageTools.wrapType2 (finalAttrs: {
  pname = "altus";
  version = "5.8.1";

  src = fetchurl {
    name = "altus-${finalAttrs.version}.AppImage";
    url = "https://github.com/amanharwara/altus/releases/download/${finalAttrs.version}/Altus-${finalAttrs.version}.AppImage";
    hash = "sha256-FSyXs9thTQ5T5bvCfg/+QXBZMIOyoijAw0dUsvLRGH8=";
  };

  nativeBuildInputs = [ makeWrapper ];

  extraInstallCommands = ''
    install -Dm 644 ${finalAttrs.contents}/Altus.desktop -t $out/share/applications
    install -Dm 644 ${finalAttrs.contents}/Altus.png -t $out/share/icons/hicolor/256x256/apps
    substituteInPlace $out/share/applications/Altus.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=altus'
    wrapProgram "$out/bin/altus" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"
  '';

  meta = {
    description = "Client for WhatsApp Web with themes, notifications and multiple accounts support";
    homepage = "https://github.com/amanharwara/altus";
    changelog = "https://github.com/amanharwara/altus/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ johnrtitor ];
    platforms = [ "x86_64-linux" ];
  };
})
