{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "cloudflared";
  version = "2021.7.4";

  src = fetchFromGitHub {
    owner  = "cloudflare";
    repo   = "cloudflared";
    rev    = version;
    sha256 = "sha256-3HK7QLUhU6MUayRYec4LP2BfbwEsvtjtCf++o1cQsQw=";
  };

  vendorSha256 = null;

  doCheck = false;

  buildFlagsArray = "-ldflags=-X main.Version=${version}";

  meta = with lib; {
    description = "CloudFlare Argo Tunnel daemon (and DNS-over-HTTPS client)";
    homepage    = "https://www.cloudflare.com/products/argo-tunnel";
    license     = licenses.unfree;
    platforms   = platforms.unix;
    maintainers = [ maintainers.thoughtpolice maintainers.enorris ];
  };
}
