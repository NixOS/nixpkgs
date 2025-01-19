{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
  ...
}:
buildGoModule rec {
  pname = "cloud-provider-aws";
  version = "1.28.1";

  src = fetchFromGitHub {
    owner = "kubernetes";
    repo = "cloud-provider-aws";
    rev = "v${version}";
    sha256 = "sha256-v+RTrcjEfo4A9DhPWElwSp8wYQ9HAt4p+8cQqSsy7ak=";
  };

  subPackages = [
    "cmd/aws-cloud-controller-manager"
    "cmd/ecr-credential-provider"
  ];

  CGO_ENABLED = 0;

  ldflags = [
    "-s -w -X k8s.io/component-base/version.gitVersion=v${version} -X main.gitVersion=v${version}"
  ];

  vendorHash = "sha256-Msmc/yVYBAnuKUk77846BznaUGu6ZFbD8CqldoHJ/u8=";

  doCheck = false;

  meta = with lib; {
    description = "The AWS cloud provider provides the interface between a Kubernetes cluster and AWS service APIs. This project allows a Kubernetes cluster to provision, monitor and remove AWS resources necessary for operation of the cluster.";
    homepage = "https://github.com/kubernetes/cloud-provider-aws/";
    maintainers = with maintainers; [ fangpen ];
    license = licenses.asl20;
  };
}
