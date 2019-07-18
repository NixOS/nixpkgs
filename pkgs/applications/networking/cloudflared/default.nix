{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name    = "cloudflared-${version}";
  version = "2019.7.0";

  goPackagePath = "github.com/cloudflare/cloudflared";

  src = fetchFromGitHub {
    owner  = "cloudflare";
    repo   = "cloudflared";
    rev    = version;
    sha256 = "19229p7c9m7v0xpmzi5rfwjzm845ikq8pndkry2si9azks18x77q";
  };

  goDeps = ./deps.nix;

  buildFlagsArray = "-ldflags=-X main.Version=${version}";

  meta = with stdenv.lib; {
    description = "CloudFlare Argo Tunnel daemon (and DNS-over-HTTPS client)";
    homepage    = https://www.cloudflare.com/products/argo-tunnel;
    license     = licenses.unfree;
    platforms   = platforms.unix;
    maintainers = [ maintainers.thoughtpolice maintainers.enorris ];
  };
}
