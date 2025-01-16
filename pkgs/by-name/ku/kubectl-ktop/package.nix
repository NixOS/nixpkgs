{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "kubectl-ktop";
  version = "0.3.7";

  src = fetchFromGitHub {
    owner = "vladimirvivien";
    repo = "ktop";
    rev = "v${version}";
    sha256 = "sha256-oxyEkDY53HjBgjWRajlcg+8Kx092lyLkPgOJleioO7o=";
  };

  vendorHash = "sha256-MLIcTHWo7lsqtAqH8naSvpS013t8KBVPRbch+CfeUNk=";

  excludedPackages = [ ".ci" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/vladimirvivien/ktop/buildinfo.Version=v${version}"
    "-X github.com/vladimirvivien/ktop/buildinfo.GitSHA=${src.rev}"
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
    changelog = "https://github.com/vladimirvivien/ktop/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [
      qjoly
      ivankovnatsky
    ];
  };
}
