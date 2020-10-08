{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "nextdns";
  version = "1.8.3";

  src = fetchFromGitHub {
    owner = "nextdns";
    repo = "nextdns";
    rev = "v${version}";
    sha256 = "1bl6ky258hnai4v7d0gskn6nf5sdsc3xlwl959iwzqhpp0j3q9xg";
  };

  vendorSha256 = "09whpzsn16znyrknfm5zlhla253r69j6d751czza4c83m4r36swj";

  doCheck = false;

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version}" ];

  meta = with lib; {
    description = "NextDNS DNS/53 to DoH Proxy";
    homepage = "https://nextdns.io";
    license = licenses.mit;
    maintainers = with maintainers; [ pnelson ];
  };
}
