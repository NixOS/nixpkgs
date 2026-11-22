{
  pname,
  version,
  src,
  meta,
  updateScript,
  appimageTools,
  makeWrapper,
}:

appimageTools.wrapType2 (finalAttrs: {
  inherit
    pname
    version
    src
    meta
    ;

  passthru = { inherit updateScript; };

  nativeBuildInputs = [ makeWrapper ];

  extraInstallCommands = ''
    wrapProgram $out/bin/lens-desktop \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"
    install -m 444 -D ${finalAttrs.contents}/lens-desktop.desktop $out/share/applications/lens-desktop.desktop
    install -m 444 -D ${finalAttrs.contents}/usr/share/icons/hicolor/512x512/apps/lens-desktop.png \
       $out/share/icons/hicolor/512x512/apps/lens-desktop.png
    substituteInPlace $out/share/applications/lens-desktop.desktop \
      --replace 'Exec=AppRun' 'Exec=lens-desktop'
  '';

  extraPkgs = pkgs: [ pkgs.nss_latest ];
})
