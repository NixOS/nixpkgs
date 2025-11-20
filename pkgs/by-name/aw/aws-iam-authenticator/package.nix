{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "aws-iam-authenticator";
  version = "0.7.9";

  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = "aws-iam-authenticator";
    tag = "v${version}";
    hash = "sha256-+c9LjWXNK2XtvhpQK3hzuVQVHQxSEDgh994Iys69x9U=";
  };

  vendorHash = "sha256-gTNrHvilSYqKAO164VgbIzwVdZt2nS7Xmh6DOU7QEZc=";

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
