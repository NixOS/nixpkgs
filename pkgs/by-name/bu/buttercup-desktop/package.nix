{
  lib,
  fetchurl,
  appimageTools,
}:

appimageTools.wrapType2 (finalAttrs: {
  pname = "buttercup-desktop";
  version = "2.28.1";

  src = fetchurl {
    url = "https://github.com/buttercup/buttercup-desktop/releases/download/v${finalAttrs.version}/Buttercup-linux-x86_64.AppImage";
    sha256 = "sha256-iCuvs+FisYPvCmPVg1dhYMX+Lw3WmrMSRytdy6TLrxg=";
  };

  extraPkgs = pkgs: [ pkgs.libsecret ];

  extraInstallCommands = ''
    install -m 444 -D ${finalAttrs.contents}/buttercup.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/buttercup.desktop \
      --replace 'Exec=AppRun' 'Exec=buttercup-desktop'
    cp -r ${finalAttrs.contents}/usr/share/icons $out/share
  '';

  meta = {
    description = "Cross-Platform Passwords & Secrets Vault";
    mainProgram = "buttercup-desktop";
    homepage = "https://buttercup.pw";
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
    platforms = [ "x86_64-linux" ];
  };
})
