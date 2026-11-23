{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "kubectl-ktop";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "vladimirvivien";
    repo = "ktop";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8y+E5FjBJES+h8uAA63lk3bHh+wGyAoeoZPlmDoo088=";
  };

  vendorHash = "sha256-xJm8XCShiPPPPguU89bmpjmYGuRlegcvtV178Vi77i0=";

  excludedPackages = [ ".ci" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/vladimirvivien/ktop/buildinfo.Version=v${finalAttrs.version}"
    "-X github.com/vladimirvivien/ktop/buildinfo.GitSHA=${finalAttrs.src.tag}"
  ];

  postInstall = ''
    ln -s $out/bin/ktop $out/bin/kubectl-ktop
  '';

  doCheck = false;

  meta = {
    description = "Top-like tool for your Kubernetes clusters";
    mainProgram = "kubectl-ktop";
    longDescription = ''
      Following the tradition of Unix/Linux top tools, ktop is a tool that displays useful metrics information about nodes, pods, and other workload resources running in a Kubernetes cluster.
    '';
    homepage = "https://github.com/vladimirvivien/ktop";
    changelog = "https://github.com/vladimirvivien/ktop/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      qjoly
      ivankovnatsky
    ];
  };
})
