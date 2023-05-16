{ lib, stdenv, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "velero";
<<<<<<< HEAD
  version = "1.11.1";
=======
  version = "1.10.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)


  src = fetchFromGitHub {
    owner = "vmware-tanzu";
    repo = "velero";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-G1+zdzHj8fDKVEVQpBEH3o/em+gxCyQmrpSXj8bE/P4=";
=======
    sha256 = "sha256-tNWFZrvq9bDV00TSM+q9D05Tc25judNzRxn0nU/RnCc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  ldflags = [
    "-s" "-w"
    "-X github.com/vmware-tanzu/velero/pkg/buildinfo.Version=v${version}"
    "-X github.com/vmware-tanzu/velero/pkg/buildinfo.ImageRegistry=velero"
    "-X github.com/vmware-tanzu/velero/pkg/buildinfo.GitTreeState=clean"
    "-X github.com/vmware-tanzu/velero/pkg/buildinfo.GitSHA=none"
  ];

<<<<<<< HEAD
  vendorHash = "sha256-WkJk+46+9U4TegDnGtQ+EoqqV/D7githz2pJvxCbV4c=";
=======
  vendorHash = "sha256-8yyZ6qIQqpl9PSvaCwhU/i2ZwRe171oMVGqFWeOZExo=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
