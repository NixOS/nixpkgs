{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "cloudflared";
  version = "2020.2.0";

  src = fetchFromGitHub {
    owner  = "cloudflare";
    repo   = "cloudflared";
    rev    = version;
    sha256 = "1fzndqkmfpx15fllxqxbh7n4m13ydlp50dvkdh8n384j09ndmx4r";
  };

  modSha256 = "1y5vh8g967rrm9b9hjlr70bs2rm09cpik673brgk3nzqxka10w7p";

  buildFlagsArray = "-ldflags=-X main.Version=${version}";

  meta = with stdenv.lib; {
    description = "CloudFlare Argo Tunnel daemon (and DNS-over-HTTPS client)";
    homepage    = "https://www.cloudflare.com/products/argo-tunnel";
    license     = licenses.unfree;
    platforms   = platforms.unix;
    maintainers = [ maintainers.thoughtpolice maintainers.enorris ];
  };
}
