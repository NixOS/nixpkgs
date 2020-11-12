{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "cloudflared";
  version = "2020.11.3";

  src = fetchFromGitHub {
    owner  = "cloudflare";
    repo   = "cloudflared";
    rev    = version;
    sha256 = "1v262wr1z0z3frb9avg6bgsv973cn6gmn4w6wghpcjwsm6jld575";
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
