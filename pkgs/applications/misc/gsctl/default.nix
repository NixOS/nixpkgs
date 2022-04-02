{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gsctl";
  version = "1.1.4";

  src = fetchFromGitHub {
    owner = "giantswarm";
    repo = pname;
    rev = version;
    sha256 = "sha256-uCNWgaLZMm1vPxFduj8mpjKYuYlp1ChF6bK+bmAWy50=";
  };

  vendorSha256 = "sha256-lZgHrQYqoyoM1Iv6vCqTMcv62zSKyxaAsq56kUXHrIA=";

  ldflags =
    [ "-s" "-w" "-X github.com/giantswarm/gsctl/buildinfo.Version=${version}" ];

  doCheck = false;

  meta = with lib; {
    description = "The Giant Swarm command line interface";
    homepage = "https://github.com/giantswarm/gsctl";
    license = licenses.asl20;
    maintainers = with maintainers; [ joesalisbury ];
  };
}
