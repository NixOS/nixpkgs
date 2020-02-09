{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "cloudflared";
  version = "2019.12.0";

  src = fetchFromGitHub {
    owner  = "cloudflare";
    repo   = "cloudflared";
    rev    = version;
    sha256 = "0cc78bysp7z76h4ddiwbsrygz4m4r71f8xylg99pc5qyg8p3my4p";
  };

  modSha256 = "1y5vh8g967rrm9b9hjlr70bs2rm09cpik673brgk3nzqxka10w7p";

  buildFlagsArray = "-ldflags=-X main.Version=${version}";

  meta = with stdenv.lib; {
    description = "CloudFlare Argo Tunnel daemon (and DNS-over-HTTPS client)";
    homepage    = https://www.cloudflare.com/products/argo-tunnel;
    license     = licenses.unfree;
    platforms   = platforms.unix;
    maintainers = [ maintainers.thoughtpolice maintainers.enorris ];
  };
}
