{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "helm-docs";
  version = "1.11.2";

  src = fetchFromGitHub {
    owner = "norwoodj";
    repo = "helm-docs";
    rev = "v${version}";
    hash = "sha256-w4QV96/02Pbs/l0lTLPYY8Ag21ZDDVPdgvuveiKUCoM=";
  };

  vendorHash = "sha256-6byD8FdeqdRDNUZFZ7FUUdyTuFOO8s3rb6YPGKdwLB8=";

  subPackages = [ "cmd/helm-docs" ];
  ldflags = [
    "-w"
    "-s"
    "-X main.version=${version}"
  ];

  meta = with lib; {
    homepage = "https://github.com/norwoodj/helm-docs";
    description = "A tool for automatically generating markdown documentation for Helm charts";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ sagikazarmark ];
  };
}
