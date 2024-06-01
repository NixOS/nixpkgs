{ fetchurl }:
let
  pname = "roam-research";
  version = "0.0.19";
in
{
  inherit pname version;
  sources = {
    x86_64-darwin = fetchurl {
      url = "https://roam-electron-deploy.s3.us-east-2.amazonaws.com/Roam+Research-${version}.dmg";
      hash = "sha256-pIH4p7dnmyOgGyruSJ39xB8iJ45wtxcIQmfUeBLlDes=";
    };
    aarch64-darwin = fetchurl {
      url = "https://roam-electron-deploy.s3.us-east-2.amazonaws.com/Roam+Research-${version}-arm64.dmg";
      hash = "sha256-iQRaaSU033t3WVWZSKuXCPJbMoNpwLnDHBz5QURu6Gw=";
    };
    x86_64-linux = fetchurl {
      url = "https://roam-electron-deploy.s3.us-east-2.amazonaws.com/${pname}_${version}_amd64.deb";
      hash = "sha256-eDN+hrAc+ePRELcXAs5WypzPlJ+Wtg3kUarf8rq5CnA=";
    };
  };
}
