{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "cloudflared";
  version = "2020.10.0";

  src = fetchFromGitHub {
    owner  = "cloudflare";
    repo   = "cloudflared";
    rev    = version;
    sha256 = "1ssmyll13pf19fxq34iw4x7ps8p4mcg9nwlx00hp5sahhwx4iz01";
  };

  vendorSha256 = null;

  doCheck = false;

  buildFlagsArray = "-ldflags=-X main.Version=${version}";

  meta = with stdenv.lib; {
    description = "CloudFlare Argo Tunnel daemon (and DNS-over-HTTPS client)";
    homepage    = "https://www.cloudflare.com/products/argo-tunnel";
    license     = licenses.unfree;
    platforms   = platforms.unix;
    maintainers = [ maintainers.thoughtpolice maintainers.enorris ];
  };
}
