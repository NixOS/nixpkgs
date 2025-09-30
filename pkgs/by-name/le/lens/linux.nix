{
  pname,
  version,
  src,
  meta,
  appimageTools,
  makeWrapper,
}:
let
  appimageContents = appimageTools.extractType2 {
    inherit pname version src;
  };

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
    wrapProgram $out/bin/${pname} \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"
    install -m 444 -D ${appimageContents}/${pname}.desktop $out/share/applications/${pname}.desktop
    install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/512x512/apps/${pname}.png \
       $out/share/icons/hicolor/512x512/apps/${pname}.png
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
  '';

  extraPkgs = pkgs: [ pkgs.nss_latest ];
}
