{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "nextdns";
  version = "1.40.1";

  src = fetchFromGitHub {
    owner = "nextdns";
    repo = "nextdns";
    rev = "v${version}";
    sha256 = "sha256-VK6e8+r0A642zP0Pae8qbQCWT+CGpHY7B9ZGobXl92A=";
  };

  vendorHash = "sha256-CKKyLtqSzbmvpmDcoyGD79msAudlumqxcXaMTNbCbNI=";

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  meta = with lib; {
    description = "NextDNS DNS/53 to DoH Proxy";
    homepage = "https://nextdns.io";
    license = licenses.mit;
    maintainers = with maintainers; [ pnelson ];
  };
}
