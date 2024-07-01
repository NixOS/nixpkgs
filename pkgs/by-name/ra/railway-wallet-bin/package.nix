{ lib
, appimageTools
, fetchurl
}:

appimageTools.wrapType2 rec {
  pname = "railway-wallet-bin";
  version = "5.16.9";

  src = fetchurl {
    url = "https://github.com/Railway-Wallet/Railway-Wallet/releases/download/v${version}/Railway-linux-x86_64.AppImage";
    hash = "sha256-UI/eJoQFtWzP/vMumJVp8BRylmUqRMTdbAJpFYDzsh8=";
  };

  meta = {
    description = "Private DeFi wallet for Linux";
    homepage = "https://www.railway.xyz";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ mitchmindtree ];
    platforms = [ "x86_64-linux" ];
  };
}
