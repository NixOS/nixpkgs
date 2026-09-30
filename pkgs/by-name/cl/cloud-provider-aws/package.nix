{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
  ...
}:
buildGoModule rec {
  pname = "cloud-provider-aws";
  version = "1.28.11";

  src = fetchFromGitHub {
    owner = "kubernetes";
    repo = "cloud-provider-aws";
    tag = "v${version}";
    hash = "sha256-wsbhJLkJyenc59wwCy+M0cpRqarO7UxLFS6dy6FDY/A=";
  };

  subPackages = [
    "cmd/aws-cloud-controller-manager"
    "cmd/ecr-credential-provider"
  ];

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s -w -X k8s.io/component-base/version.gitVersion=v${version} -X main.gitVersion=v${version}"
  ];

  vendorHash = "sha256-ZZ28dx5QZLU4bOOgno0bfsFooa7fR/laIomjEKShKLQ=";

  doCheck = false;

  meta = {
    description = "Kubernetes tools for AWS services, such as ECR Credential Provider or EBS CSI Driver";
    homepage = "https://github.com/kubernetes/cloud-provider-aws/";
    changelog = "https://github.com/kubernetes/cloud-provider-aws/blob/${src.rev}/docs/CHANGELOG.md";
    maintainers = with lib.maintainers; [ fangpen ];
    license = lib.licenses.asl20;
  };
}
