{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "cloudflare-utils";
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "Cyb3r-Jak3";
    repo = "cloudflare-utils";
    rev = "v${version}";
    hash = "sha256-Wa8YCwOY7kwKJmME5hWpEGrC8bxjgVnli1GUwKLyFJg=";
  };

  vendorHash = "sha256-hoU+GSJHBZtb29jJbeuaFQSn496b1xLzXJtBCbKEcYE=";

  meta = {
    description = "Helpful Cloudflare utility program";
    homepage = "https://github.com/Cyb3r-Jak3/cloudflare-utils";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ yelite ];
  };
}
