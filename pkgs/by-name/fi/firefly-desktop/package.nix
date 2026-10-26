{
  lib,
  fetchurl,
  appimageTools,
}:

appimageTools.wrapType2 (finalAttrs: {
  pname = "firefly-desktop";
  version = "2.1.8";
  src = fetchurl {
    url = "https://github.com/iotaledger/firefly/releases/download/desktop-${finalAttrs.version}/firefly-desktop-${finalAttrs.version}.AppImage";
    sha256 = "sha256-MATMl5eEIauDQpz8/wqIzD7IugPVZ2HJAWCbDM4n+hA=";
  };

  extraPkgs = pkgs: [ pkgs.libsecret ];

  extraInstallCommands = ''
    install -D ${finalAttrs.contents}/desktop.desktop $out/share/applications/firefly-desktop.desktop
    substituteInPlace $out/share/applications/firefly-desktop.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=firefly-desktop' \
      --replace-fail 'Icon=desktop' 'Icon=firefly-desktop'
    install -D ${finalAttrs.contents}/desktop.png $out/share/icons/firefly-desktop.png
  '';

  meta = {
    description = "IOTA's New Wallet";
    homepage = "https://firefly.iota.org";
    license = lib.licenses.asl20;
    maintainers = [ ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "firefly-desktop";
  };
})
