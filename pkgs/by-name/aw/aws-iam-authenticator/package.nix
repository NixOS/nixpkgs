{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "aws-iam-authenticator";
  version = "0.7.10";

  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = "aws-iam-authenticator";
    tag = "v${finalAttrs.version}";
    hash = "sha256-usnLBLdgEpfpjItMwlRUnuiYQDcq+3FhOpL0WPxdYyY=";
  };

  vendorHash = "sha256-cEWsTYwWVo7UKcAjXf+dUQ8pboIUnT+0D8yFhD6WSSk=";

  ldflags =
    let
      PKG = "sigs.k8s.io/aws-iam-authenticator";
    in
    [
      "-s"
      "-w"
      "-X=${PKG}/pkg.Version=${finalAttrs.version}"
      "-X=${PKG}/pkg.BuildDate=1970-01-01T01:01:01Z"
      "-X ?${PKG}/pkg.CommitID=${finalAttrs.version}"
    ];

  subPackages = [ "cmd/aws-iam-authenticator" ];

  meta = {
    homepage = "https://github.com/kubernetes-sigs/aws-iam-authenticator";
    description = "AWS IAM credentials for Kubernetes authentication";
    mainProgram = "aws-iam-authenticator";
    changelog = "https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      srhb
      ryan4yin
    ];
  };
})
