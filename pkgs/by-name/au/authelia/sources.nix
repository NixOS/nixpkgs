{ stdenv, fetchFromGitHub }:
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
  pnpmDepsHash =
    if stdenv.hostPlatform.isAarch64 then
      "sha256-YUInqRclRdnMzxfJKuVdXwKaRzJd9sFu16dxCAgVJI8="
    else
      "sha256-zIaVEjbh/LIQMqnryrgVm+46GP+9gM91WCMyAqeDnaA=";
}
