{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "cloudflared";
  version = "2022.2.0";

  src = fetchFromGitHub {
    owner  = "cloudflare";
    repo   = "cloudflared";
    rev    = version;
    hash   = "sha256-yo4Tu9wSxGdUAr2436lAlaP2U+5m/J4+oNQd/UQk3a0=";
  };

  vendorSha256 = null;

  doCheck = false;

  ldflags = [ "-X main.Version=${version}" ];

  meta = with lib; {
    description = "CloudFlare Tunnel daemon (and DNS-over-HTTPS client)";
    homepage    = "https://www.cloudflare.com/products/tunnel";
    license     = licenses.unfree;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ bbigras enorris thoughtpolice ];
  };
}
