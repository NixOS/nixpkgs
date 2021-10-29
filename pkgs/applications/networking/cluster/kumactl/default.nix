{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "kumactl";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "kumahq";
    repo = "kuma";
    rev = version;
    sha256 = "0b554cngg2j3wnadpqwhq3dv3la8vvvzyww2diw4il4gl4j6xj0j";
  };

  vendorSha256 = "0r26h4vp11wbl7nk3y7c22p60q7lspy8nr58khxyczdqjk6wrdjp";

  subPackages = [ "app/kumactl" ];

  ldflags = let
    prefix = "github.com/kumahq/kuma/pkg/version";
  in [
    "-s" "-w"
    "-X ${prefix}.version=${version}"
    "-X ${prefix}.gitTag=${version}"
    "-X ${prefix}.gitCommit=${version}"
    "-X ${prefix}.buildDate=${version}"
  ];

  meta = with lib; {
    description = "Kuma service mesh controller";
    homepage = "https://kuma.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ zbioe ];
  };
}
