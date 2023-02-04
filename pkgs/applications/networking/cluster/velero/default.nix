{ lib, stdenv, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "velero";
  version = "1.10.0";


  src = fetchFromGitHub {
    owner = "vmware-tanzu";
    repo = "velero";
    rev = "v${version}";
    sha256 = "sha256-PBCTVws5N42q68rKcMLW7GgZvdsQgmdlsKMpJ5bCF00=";
  };

  ldflags = [
    "-s" "-w"
    "-X github.com/vmware-tanzu/velero/pkg/buildinfo.Version=v${version}"
    "-X github.com/vmware-tanzu/velero/pkg/buildinfo.ImageRegistry=velero"
    "-X github.com/vmware-tanzu/velero/pkg/buildinfo.GitTreeState=clean"
    "-X github.com/vmware-tanzu/velero/pkg/buildinfo.GitSHA=none"
  ];

  vendorSha256 = "sha256-5Po8TRCE6VP+RcaIJImYjElTMHHS/2JwbrHreeWLxio=";

  excludedPackages = [ "issue-template-gen" "release-tools" "v1" "velero-restic-restore-helper" ];

  doCheck = false; # Tests expect a running cluster see https://github.com/vmware-tanzu/velero/tree/main/test/e2e
  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/velero version --client-only | grep ${version} > /dev/null
  '';

  nativeBuildInputs = [ installShellFiles ];
  postInstall = lib.optionalString (stdenv.hostPlatform == stdenv.buildPlatform) ''
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
