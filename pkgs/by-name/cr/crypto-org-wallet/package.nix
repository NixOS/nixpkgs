{
  lib,
  fetchurl,
  appimageTools,
  imagemagick,
}:

appimageTools.wrapAppImage rec {
  pname = "chain-desktop-wallet";
  version = "1.5.1";

  src = appimageTools.extractType2 {
    inherit pname version;
    src = fetchurl {
      url = "https://github.com/crypto-com/chain-desktop-wallet/releases/download/v${version}/Crypto.com-DeFi-Desktop-Wallet-${version}.AppImage";
      hash = "sha256-dXJMU6abg31ZyETKl5Hh6fxn1Gd1FbSHGJh1z0R7XPM=";
    };
  };

  extraInstallCommands = ''
    install -m 444 -D ${src}/chain-desktop-wallet.desktop $out/share/applications/chain-desktop-wallet.desktop
    ${imagemagick}/bin/magick ${src}/chain-desktop-wallet.png -resize 512x512 chain-desktop-wallet_512.png
    install -m 444 -D chain-desktop-wallet_512.png $out/share/icons/hicolor/512x512/apps/chain-desktop-wallet.png
    substituteInPlace $out/share/applications/chain-desktop-wallet.desktop \
      --replace-fail "Exec=AppRun --no-sandbox %U" "Exec=chain-desktop-wallet %U"
  '';

  meta = {
    description = "Crypto.org Chain desktop wallet (Beta)";
    homepage = "https://github.com/crypto-com/chain-desktop-wallet";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ th0rgal ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "chain-desktop-wallet";
  };
}
