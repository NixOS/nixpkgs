{
  lib,
  fetchurl,
  appimageTools,
}:

appimageTools.wrapType2 (finalAttrs: {
  pname = "mobilecoin-wallet";
  version = "1.9.2";
  src = fetchurl {
    url = "https://github.com/mobilecoinofficial/desktop-wallet/releases/download/v${finalAttrs.version}/MobileCoin.Wallet-${finalAttrs.version}.AppImage";
    hash = "sha256-JfG+eHsPFXZKi9Vjbw7CPvhmeMvfPWSDS65Ey4Lb8iQ=";
  };

  extraPkgs = pkgs: [ pkgs.libsecret ];

  extraInstallCommands = ''
    mkdir -p $out/share/${finalAttrs.pname}
    cp -a ${finalAttrs.contents}/locales $out/share/${finalAttrs.pname}
    cp -a ${finalAttrs.contents}/resources $out/share/${finalAttrs.pname}
    cp -a ${finalAttrs.contents}/usr/share/icons $out/share/

    install -Dm 644 ${finalAttrs.contents}/${finalAttrs.pname}.desktop -t $out/share/applications/

    substituteInPlace $out/share/applications/${finalAttrs.pname}.desktop \
      --replace "AppRun" "${finalAttrs.pname}"
  '';

  meta = {
    description = "User-friendly desktop wallet with support for transaction history, encrypted contact book, gift codes, and payments";
    homepage = "https://github.com/mobilecoinofficial/desktop-wallet";
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
    mainProgram = "mobilecoin-wallet";
    platforms = [ "x86_64-linux" ];
  };
})
