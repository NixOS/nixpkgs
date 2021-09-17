{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "nextdns";
  version = "1.37.2";

  src = fetchFromGitHub {
    owner = "nextdns";
    repo = "nextdns";
    rev = "v${version}";
    sha256 = "sha256-R0n/wRCaQ8WvQer3bBLUmOdIojtfjXU0bs0pTn7L0lc=";
  };

  vendorSha256 = "sha256-YZm+DUrH+1xdJrGjmlajbcsnqVODVbZKivVjmqZ2e48=";

  doCheck = false;

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  meta = with lib; {
    description = "NextDNS DNS/53 to DoH Proxy";
    homepage = "https://nextdns.io";
    license = licenses.mit;
    maintainers = with maintainers; [ pnelson ];
  };
}
