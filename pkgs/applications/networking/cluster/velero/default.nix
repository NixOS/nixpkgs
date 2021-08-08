{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "velero";
  # When updating, change the commit underneath
  version = "1.6.2";
  commit = "8c9cdb9603446760452979dc77f93b17054ea1cc";


  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "vmware-tanzu";
    repo = "velero";
    sha256 = "sha256-JYa+5lP9uo/6/5wTxNz8xa2usHo6WfXSndbwrMpHhcg=";
  };

  buildFlagsArray = ''
    -ldflags=
      -s -w
      -X github.com/vmware-tanzu/velero/pkg/buildinfo.Version=${version}
      -X github.com/vmware-tanzu/velero/pkg/buildinfo.GitSHA=${commit}
      -X github.com/vmware-tanzu/velero/pkg/buildinfo.GitTreeState=clean
  '';

  vendorSha256 = "sha256-Rmj2qGY2w1gsnKAuRQ8cQyqfoM556t4/MookkuPmbDM=";

  excludedPackages = [ "issue-template-gen" "crd-gen" "release-tools" "velero-restic-restore-helper" ];

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
