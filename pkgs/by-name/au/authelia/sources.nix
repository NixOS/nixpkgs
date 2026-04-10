{ fetchFromGitHub }:
rec {
  pname = "authelia";
  version = "4.39.28";

  src = fetchFromGitHub {
    owner = "authelia";
    repo = "authelia";
    rev = "v${version}";
    hash = "sha256-PeXpxj9xD8KYa2W9C1qLmzm1HR7TWseX/33GSRezseM=";
  };
  vendorHash = "sha256-Bi3cAkcVP1ZWFBuy0RfpqW7yqyV5DxSsa6gmtfLgxEA=";
  pnpmDepsHash = "sha256-B/Au9YICuRM6+J4DojFbXf2IEWC+j1jRsU68nn08Puk=";
}
