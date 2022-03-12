{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "cloudflared";
  version = "2022.3.1";

  src = fetchFromGitHub {
    owner  = "cloudflare";
    repo   = "cloudflared";
    rev    = version;
    hash   = "sha256-iVg+AXSBO+caeYxUR41infCvsCTZkJTf7K0oZnOQmnY=";
  };

  vendorSha256 = null;

  doCheck = false;

  ldflags = [ "-X main.Version=${version}" ];

  meta = with lib; {
    description = "CloudFlare Tunnel daemon (and DNS-over-HTTPS client)";
    homepage    = "https://www.cloudflare.com/products/tunnel";
    license     = licenses.asl20;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ bbigras enorris thoughtpolice ];
  };
}
