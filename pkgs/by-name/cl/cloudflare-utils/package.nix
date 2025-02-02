{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "cloudflare-utils";
  version = "1.3.4";

  src = fetchFromGitHub {
    owner = "Cyb3r-Jak3";
    repo = "cloudflare-utils";
    rev = "v${version}";
    hash = "sha256-XYOYun7PmZEQQRVCi46tBYoNZdXedmhpdUygtVlU0bE=";
  };

  vendorHash = "sha256-fg2BJkXdCWAO83kMoxkHlEyZuVezu9rs0hEda17KObE=";

  meta = {
    description = "Helpful Cloudflare utility program";
    homepage = "https://github.com/Cyb3r-Jak3/cloudflare-utils";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ yelite ];
  };
}
