{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "cloudflare-utils";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "Cyb3r-Jak3";
    repo = "cloudflare-utils";
    rev = "v${version}";
    hash = "sha256-hmMWMV8hJblXn0aW+S/VpFu9xYdh8k1H1Oa2x5DYMY4=";
  };

  vendorHash = "sha256-c1fUMX7pSiElSWSMBIzoNIEGcnCck9eUGPYXzb2Rv3w=";

  meta = {
    description = "Helpful Cloudflare utility program";
    homepage = "https://github.com/Cyb3r-Jak3/cloudflare-utils";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [yelite];
  };
}
