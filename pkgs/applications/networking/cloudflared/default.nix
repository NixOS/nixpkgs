{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name    = "cloudflared-${version}";
  version = "2018.10.3";

  goPackagePath = "github.com/cloudflare/cloudflared";

  src = fetchFromGitHub {
    owner  = "cloudflare";
    repo   = "cloudflared";
    rev    = "41916365b689bf2cc1446ea5717e4d26cc8aed43"; # untagged
    sha256 = "109bhnmvlvj3ag9vw090fy202z8aaqr1rakhn8v550wwy30h9zkf";
  };

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    description = "CloudFlare Argo Tunnel daemon (and DNS-over-HTTPS client)";
    homepage    = https://www.cloudflare.com/products/argo-tunnel;
    license     = licenses.unfree;
    platforms   = platforms.unix;
    maintainers = [ maintainers.thoughtpolice ];
  };
}
