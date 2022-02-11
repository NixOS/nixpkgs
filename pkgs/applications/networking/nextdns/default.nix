{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "nextdns";
  version = "1.37.7";

  src = fetchFromGitHub {
    owner = "nextdns";
    repo = "nextdns";
    rev = "v${version}";
    sha256 = "sha256-L5PeT4Y2oWM1WUJaBK9xgrpfkpvKM1+sA29A3AiDE38=";
  };

  vendorSha256 = "sha256-6hWD05lXteqL7egj9tiRVHlevKM33i+a+zBUZs7PF7I=";

  doCheck = false;

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  meta = with lib; {
    description = "NextDNS DNS/53 to DoH Proxy";
    homepage = "https://nextdns.io";
    license = licenses.mit;
    maintainers = with maintainers; [ pnelson ];
  };
}
