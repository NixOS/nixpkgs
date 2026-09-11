{
  lib,
  appimageTools,
  fetchurl,
}:
appimageTools.wrapType2 rec {
  pname = "railway-wallet";
  version = "5.24.21";

  src = fetchurl {
    url = "https://github.com/Railway-Wallet/Railway-Wallet/releases/download/v${version}/Railway.linux.x86_64.AppImage";
    hash = "sha256-21Z9ulzYGIjntAHuA3t7Bl5yIqM7y39jALM4tDBa0Qw=";
  };

  meta = {
    description = "Private DeFi wallet for Linux";
    homepage = "https://www.railway.xyz";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ mitchmindtree ];
    platforms = [ "x86_64-linux" ];
  };
}
