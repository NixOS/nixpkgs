{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "aws-iam-authenticator";
  version = "0.7.7";

  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = "aws-iam-authenticator";
    tag = "v${version}";
    hash = "sha256-nnl5QPJWG0hGp15dwcMdhWCPn5Z4noydLA/Nn5koQCU=";
  };

  vendorHash = "sha256-oa0wOI7fbMjuG20g+8u5V2tbX+1R3pcRR7kn1iWMp4Y=";

  ldflags =
    let
      PKG = "sigs.k8s.io/aws-iam-authenticator";
    in
    [
      "-s"
      "-w"
      "-X=${PKG}/pkg.Version=${version}"
      "-X=${PKG}/pkg.BuildDate=1970-01-01T01:01:01Z"
      "-X ?${PKG}/pkg.CommitID=${version}"
    ];

  subPackages = [ "cmd/aws-iam-authenticator" ];

  meta = {
    homepage = "https://github.com/kubernetes-sigs/aws-iam-authenticator";
    description = "AWS IAM credentials for Kubernetes authentication";
    mainProgram = "aws-iam-authenticator";
    changelog = "https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      srhb
      ryan4yin
    ];
  };
}
