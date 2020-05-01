{ stdenv, buildGoModule, fetchFromGitHub, runCommand }:

buildGoModule rec {
  pname = "cloudflared";
  version = "2020.3.2";

  src = fetchFromGitHub {
    owner  = "cloudflare";
    repo   = "cloudflared";
    rev    = version;
    sha256 = "1vbxm5z72y9zfg4carmja3fc1vhkanmc25pgnlw550p1l14y6404";
  };

  vendorSha256 = "14w2iz3ycbzfvlr8a6qn86aaa8687cm203d73wpfkfskp277hwz0";
  deleteVendor = true;

  buildFlagsArray = "-ldflags=-X main.Version=${version}";

  meta = with stdenv.lib; {
    description = "CloudFlare Argo Tunnel daemon (and DNS-over-HTTPS client)";
    homepage    = "https://www.cloudflare.com/products/argo-tunnel";
    license     = licenses.unfree;
    platforms   = platforms.unix;
    maintainers = [ maintainers.thoughtpolice maintainers.enorris ];
  };
}
