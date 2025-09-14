{
  lib,
  appimageTools,
  makeWrapper,
  fetchurl,
}:

let
  pname = "altair";
  version = "8.2.5";

  src = fetchurl {
    url = "https://github.com/imolorhe/altair/releases/download/v${version}/altair_${version}_x86_64_linux.AppImage";
    hash = "sha256-P0CVJFafrsvWzDWyJZEds812m3yUDpo4eocysEIQqrw=";
  };

  appimageContents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit src pname version;

  nativeBuildInputs = [ makeWrapper ];

  extraInstallCommands = ''
    wrapProgram $out/bin/altair \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"

    install -m 444 -D ${appimageContents}/altair.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/altair.desktop \
      --replace 'Exec=AppRun' 'Exec=altair'
    cp -r ${appimageContents}/usr/share/icons $out/share
  '';

  meta = {
    description = "Feature-rich GraphQL Client IDE";
    mainProgram = "altair";
    homepage = "https://github.com/imolorhe/altair";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ evalexpr ];
    platforms = [ "x86_64-linux" ];
  };
}
