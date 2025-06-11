{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "cloudflare-utils";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "Cyb3r-Jak3";
    repo = "cloudflare-utils";
    rev = "v${version}";
    hash = "sha256-/vausJEe5g6Txgq1z7oUUku0w6sd/mmYcZQ8D7dZ03E=";
  };

  vendorHash = "sha256-/kbXAljCe07dC/jL4RMeN8tKXhSPMxXY33CqBDySA8w=";

  meta = {
    description = "Helpful Cloudflare utility program";
    homepage = "https://github.com/Cyb3r-Jak3/cloudflare-utils";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ yelite ];
  };
}
