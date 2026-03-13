{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "kubectl-ktop";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "vladimirvivien";
    repo = "ktop";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-CUMQsgXhypSSR1MC7hJtkZgRcM2/x6jsPVudIvRy9qM=";
  };

  vendorHash = "sha256-kSDbQFiZ8XMKyW7aYKe1s0pq038YC+RORCtMXFI+knA=";

  excludedPackages = [ ".ci" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/vladimirvivien/ktop/buildinfo.Version=v${finalAttrs.version}"
    "-X github.com/vladimirvivien/ktop/buildinfo.GitSHA=${finalAttrs.src.rev}"
  ];

  postInstall = ''
    ln -s $out/bin/ktop $out/bin/kubectl-ktop
    rm $out/bin/hack
  '';

  doCheck = false;

  meta = with lib; {
    description = "Top-like tool for your Kubernetes clusters";
    mainProgram = "kubectl-ktop";
    longDescription = ''
      Following the tradition of Unix/Linux top tools, ktop is a tool that displays useful metrics information about nodes, pods, and other workload resources running in a Kubernetes cluster.
    '';
    homepage = "https://github.com/vladimirvivien/ktop";
    changelog = "https://github.com/vladimirvivien/ktop/releases/tag/v${finalAttrs.version}";
    license = licenses.asl20;
    maintainers = with maintainers; [
      qjoly
      ivankovnatsky
    ];
  };
})
