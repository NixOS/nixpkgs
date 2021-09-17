{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "cloudflared";
  version = "2021.9.0";

  src = fetchFromGitHub {
    owner  = "cloudflare";
    repo   = "cloudflared";
    rev    = version;
    sha256 = "sha256-djgMTCDIVcaPI6to/pPN2hPi1tsKPxRCT30EL0OOEQU=";
  };

  vendorSha256 = null;

  doCheck = false;

  ldflags = [ "-X main.Version=${version}" ];

  meta = with lib; {
    description = "CloudFlare Argo Tunnel daemon (and DNS-over-HTTPS client)";
    homepage    = "https://www.cloudflare.com/products/argo-tunnel";
    license     = licenses.unfree;
    platforms   = platforms.unix;
    maintainers = [ maintainers.thoughtpolice maintainers.enorris ];
  };
}
