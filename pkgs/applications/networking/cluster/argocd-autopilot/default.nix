{ lib, stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "argocd-autopilot";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "argoproj-labs";
    repo = "argocd-autopilot";
    rev = "v${version}";
    sha256 = "sha256-24PWSW0qXTUqAmIAb2a/cNs3y5lXnhvzp4y92OlIaxE=";
  };

  vendorSha256 = "sha256-rJj9GFNX9OUMzkdr9D9dzucSZe10iW2LpqybhXD0m6s=";

  proxyVendor = true;

  ldflags =
    let package_url = "github.com/argoproj-labs/argocd-autopilot/pkg/store"; in
    [
      "-s"
      "-w"
      "-X ${package_url}.binaryName=${pname}"
      "-X ${package_url}.version=${src.rev}"
      "-X ${package_url}.buildDate=unknown"
      "-X ${package_url}.gitCommit=${src.rev}"
      "-X ${package_url}.installationManifestsURL=github.com/argoproj-labs/argocd-autopilot/manifests/base?ref=${src.rev}"
      "-X ${package_url}.installationManifestsNamespacedURL=github.com/argoproj-labs/argocd-autopilot/manifests/insecure?ref=${src.rev}"
    ];

  subPackages = [ "cmd" ];

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/argocd-autopilot version | grep ${src.rev} > /dev/null
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -Dm755 "$GOPATH/bin/cmd" -T $out/bin/argocd-autopilot

    runHook postInstall
  '';

  meta = with lib; {
    description = "ArgoCD Autopilot";
    downloadPage = "https://github.com/argoproj-labs/argocd-autopilot";
    homepage = "https://argocd-autopilot.readthedocs.io/en/stable/";
    license = licenses.asl20;
    maintainers = with maintainers; [ sagikazarmark bryanasdev000 ];
  };
}
