{
  lib,
  appimageTools,
  fetchurl,
}:
appimageTools.wrapType2 rec {
  pname = "railway-wallet";
  version = "5.22.3";

  src = fetchurl {
    url = "https://github.com/Railway-Wallet/Railway-Wallet/releases/download/v${version}/Railway-v${version}-linux-x86_64.AppImage";
    hash = "sha256-Y0t4YzzJwIfRYHV3GIETeRfxoRJptQ83RoacP3kdYtc=";
  };

  meta = {
    description = "Private DeFi wallet for Linux";
    homepage = "https://www.railway.xyz";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ mitchmindtree ];
    platforms = [ "x86_64-linux" ];
  };
}
