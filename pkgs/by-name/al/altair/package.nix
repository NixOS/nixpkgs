{
  lib,
  appimageTools,
  makeWrapper,
  fetchurl,
}:

appimageTools.wrapType2 (finalAttrs: {
  pname = "altair";
  version = "8.5.3";

  src = fetchurl {
    url = "https://github.com/altair-graphql/altair/releases/download/v${finalAttrs.version}/altair_${finalAttrs.version}_x86_64_linux.AppImage";
    sha256 = "sha256-XPw4NCtkInCes471as0Vtvr/SMRaJS6MNBGg0oo/Dro=";
  };

  nativeBuildInputs = [ makeWrapper ];

  extraInstallCommands = ''
    wrapProgram $out/bin/altair \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"

    install -m 444 -D ${finalAttrs.contents}/altair.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/altair.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=altair'
    cp -r ${finalAttrs.contents}/usr/share/icons $out/share
  '';

  meta = {
    description = "Feature-rich GraphQL Client IDE";
    mainProgram = "altair";
    homepage = "https://github.com/altair-graphql/altair";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ evalexpr ];
    platforms = [ "x86_64-linux" ];
  };
})
