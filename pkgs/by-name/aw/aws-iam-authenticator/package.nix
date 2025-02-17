{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "aws-iam-authenticator";
  version = "0.6.30";

  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-pgAk2qhsJTXbaXtdmKkA5GUIJt2ShWJ1mG6h0Zuh+Ng=";
  };

  vendorHash = "sha256-dR98s5g2KFGJIFbgYHmW2813GEhLFZZvV5nja84a0Ik=";

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

  meta = with lib; {
    homepage = "https://github.com/kubernetes-sigs/aws-iam-authenticator";
    description = "AWS IAM credentials for Kubernetes authentication";
    mainProgram = "aws-iam-authenticator";
    changelog = "https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ srhb ];
  };
}
