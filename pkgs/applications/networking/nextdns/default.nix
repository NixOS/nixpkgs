{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "nextdns";
  version = "1.41.0";

  src = fetchFromGitHub {
    owner = "nextdns";
    repo = "nextdns";
    rev = "v${version}";
    sha256 = "sha256-uLX5M9DW8wfVKSV+/pwy+ZK6M6OQSq7qYjRcBvOOqOQ=";
  };

  vendorHash = "sha256-vYE/GdN2ooSW4LMg1D5t5zOgATruB4Q449JdNo87fkM=";

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  meta = with lib; {
    description = "NextDNS DNS/53 to DoH Proxy";
    homepage = "https://nextdns.io";
    license = licenses.mit;
    maintainers = with maintainers; [ pnelson ];
    mainProgram = "nextdns";
  };
}
