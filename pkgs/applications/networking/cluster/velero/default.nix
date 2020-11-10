{ stdenv, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "velero";
  version = "1.5.1";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "vmware-tanzu";
    repo = "velero";
    sha256 = "1rmymwmglcia5j0c692g34hlffba1yqs2s0iyjpafma2zabrcnai";
  };

  buildFlagsArray = ''
    -ldflags=
      -s -w
      -X github.com/vmware-tanzu/velero/pkg/buildinfo.Version=${version}
      -X github.com/vmware-tanzu/velero/pkg/buildinfo.GitSHA=87d86a45a6ca66c6c942c7c7f08352e26809426c
      -X github.com/vmware-tanzu/velero/pkg/buildinfo.GitTreeState=clean
  '';

  vendorSha256 = "1izl7z689jf3i3wax7rfpk0jjly7nsi7vzasy1j9v5cwjy2d5z4v";

  excludedPackages = [ "issue-template-gen" ];

  doCheck = false;

  nativeBuildInputs = [ installShellFiles ];
  postInstall = ''
    $out/bin/velero completion bash > helm.bash
    $out/bin/velero completion zsh > helm.zsh
    installShellCompletion helm.{bash,zsh}
  '';

  meta = with stdenv.lib; {
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
