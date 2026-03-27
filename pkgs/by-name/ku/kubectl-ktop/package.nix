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

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/vladimirvivien/ktop/buildinfo.Version=v${finalAttrs.version}"
    "-X github.com/vladimirvivien/ktop/buildinfo.GitSHA=${finalAttrs.src.rev}"
  ];

  postInstall = ''
    ln -s $out/bin/ktop $out/bin/kubectl-ktop
  '';

  meta = {
    description = "Top-like tool for your Kubernetes clusters";
    homepage = "https://github.com/vladimirvivien/ktop";
    changelog = "https://github.com/vladimirvivien/ktop/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.ivankovnatsky ];
  };
})
