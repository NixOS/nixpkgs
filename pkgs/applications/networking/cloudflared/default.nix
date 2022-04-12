{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "cloudflared";
  version = "2022.4.1";

  src = fetchFromGitHub {
    owner  = "cloudflare";
    repo   = "cloudflared";
    rev    = version;
    hash   = "sha256-dgvXbWtLP6sXBlqcx/xpw9LIbcE4VlYZQO5rrS34+9I=";
  };

  vendorSha256 = null;

  doCheck = false;

  ldflags = [ "-X main.Version=${version}" ];

  meta = with lib; {
    description = "CloudFlare Tunnel daemon (and DNS-over-HTTPS client)";
    homepage    = "https://www.cloudflare.com/products/tunnel";
    license     = licenses.asl20;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ bbigras enorris thoughtpolice techknowlogick ];
  };
}
