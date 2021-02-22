{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "velero";
  version = "1.5.3";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "vmware-tanzu";
    repo = "velero";
    sha256 = "sha256-DZ6phJxc8n9LCSsER09K3j+pUJxkYrBZQaI4h+bcV94=";
  };

  buildFlagsArray = ''
    -ldflags=
      -s -w
      -X github.com/vmware-tanzu/velero/pkg/buildinfo.Version=${version}
      -X github.com/vmware-tanzu/velero/pkg/buildinfo.GitSHA=456eb19668f8da603756353d9179b59b5a7bfa04
      -X github.com/vmware-tanzu/velero/pkg/buildinfo.GitTreeState=clean
  '';

  vendorSha256 = "sha256-m/zShJeclZ1k8Fr9faK2x1Mpwbwun674iMPJhMw/9Mc=";

  excludedPackages = [ "issue-template-gen" ];

  doCheck = false;

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
    platforms = platforms.linux;
  };
}
