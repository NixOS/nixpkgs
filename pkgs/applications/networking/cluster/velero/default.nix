{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "velero";
  # When updating, change the commit underneath
  version = "1.7.0";
  commit = "9e52260568430ecb77ac38a677ce74267a8c2176";


  src = fetchFromGitHub {
    owner = "vmware-tanzu";
    repo = "velero";
    rev = "v${version}";
    sha256 = "sha256-n5Rk+Fyb6yAI5sRZi+WE1KyQZyGryZSP4yd/gmmsQxw=";
  };

  ldflags = [
    "-s" "-w"
    "-X github.com/vmware-tanzu/velero/pkg/buildinfo.Version=${version}"
    "-X github.com/vmware-tanzu/velero/pkg/buildinfo.GitSHA=${commit}"
    "-X github.com/vmware-tanzu/velero/pkg/buildinfo.GitTreeState=clean"
  ];

  vendorSha256 = "sha256-qsRbwLKNnuQRIsx0+sfOfR2OQ0+el0vptxz7mMew7zY=";

  excludedPackages = [ "issue-template-gen" "crd-gen" "release-tools" "velero-restic-restore-helper" "v1" "v1beta1" ];

  doCheck = false; # Tests expect a running cluster see https://github.com/vmware-tanzu/velero/tree/main/test/e2e
  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/velero version --client-only | grep ${version} > /dev/null
  '';

  nativeBuildInputs = [ installShellFiles ];
  postInstall = ''
    $out/bin/velero completion bash > velero.bash
    $out/bin/velero completion zsh > velero.zsh
    installShellCompletion velero.{bash,zsh}
  '';

  meta = with lib; {
    description =
      "A utility for managing disaster recovery, specifically for your Kubernetes cluster resources and persistent volumes";
    homepage = "https://velero.io/";
    changelog =
      "https://github.com/vmware-tanzu/velero/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = [ maintainers.mbode maintainers.bryanasdev000 ];
  };
}
