{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "nextdns";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "nextdns";
    repo = "nextdns";
    rev = "v${version}";
    sha256 = "sha256-gnWFgzfMMnn8O7zDN5LW3cMIz5/wmgEW9fI9aJBEah8=";
  };

  vendorSha256 = "sha256-kmszMqkDMaL+Z6GcZmQyeRShKKS/VGdn9vabYPW/kCc=";

  doCheck = false;

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version}" ];

  meta = with lib; {
    description = "NextDNS DNS/53 to DoH Proxy";
    homepage = "https://nextdns.io";
    license = licenses.mit;
    maintainers = with maintainers; [ pnelson ];
  };
}
