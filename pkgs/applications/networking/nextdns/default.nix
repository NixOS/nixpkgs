{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "nextdns";
  version = "1.37.11";

  src = fetchFromGitHub {
    owner = "nextdns";
    repo = "nextdns";
    rev = "v${version}";
    sha256 = "sha256-BOmu4OjDq1IwsPjbqzV2OtvKpaYFqP/XdYL2Ug28TbU=";
  };

  vendorSha256 = "sha256-M2PlvUsEG3Um+NqbpHdtu9g+Gj6jSXZ9YZ7t1MwjjdI=";

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  meta = with lib; {
    description = "NextDNS DNS/53 to DoH Proxy";
    homepage = "https://nextdns.io";
    license = licenses.mit;
    maintainers = with maintainers; [ pnelson ];
  };
}
