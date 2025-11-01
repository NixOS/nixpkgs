{
  pname,
  version,
  src,
  meta,
  appimageTools,
  makeWrapper,
}:
let
  appimageContents = appimageTools.extractType2 { inherit pname version src; };

in
appimageTools.wrapType2 {
  inherit
    pname
    version
    src
    meta
    ;

  nativeBuildInputs = [ makeWrapper ];

  extraInstallCommands = ''
    mv $out/bin/${pname} $out/bin/freelens
    wrapProgram $out/bin/freelens --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"
    install -m 444 -D ${appimageContents}/freelens.desktop $out/share/applications/freelens.desktop
    install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/512x512/apps/freelens.png $out/share/icons/hicolor/512x512/apps/freelens.png
    substituteInPlace $out/share/applications/freelens.desktop --replace-fail 'Exec=AppRun' 'Exec=freelens'
  '';
}
