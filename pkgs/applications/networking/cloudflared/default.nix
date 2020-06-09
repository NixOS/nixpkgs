{ stdenv, buildGoModule, fetchFromGitHub, runCommand }:

buildGoModule rec {
  pname = "cloudflared";
  version = "2020.5.1";

  src = fetchFromGitHub {
    owner  = "cloudflare";
    repo   = "cloudflared";
    rev    = version;
    sha256 = "0r1n3a8h8gyww4p2amb24jmp8zkyxy1ava3nbqgwlfjr3zagga00";
  };

  vendorSha256 = "1w93s5vp31rmnwchrq1875wx6nppw2rmqcp3adjsrahqpjfaax02";
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
