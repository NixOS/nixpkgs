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

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/vladimirvivien/ktop/buildinfo.Version=v${version}"
    "-X github.com/vladimirvivien/ktop/buildinfo.GitSHA=${src.rev}"
  ];

  postInstall = ''
    ln -s $out/bin/ktop $out/bin/kubectl-ktop
  '';

  meta = with lib; {
    description = "Top-like tool for your Kubernetes clusters";
    homepage = "https://github.com/vladimirvivien/ktop";
    changelog = "https://github.com/vladimirvivien/ktop/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = [ maintainers.ivankovnatsky ];
  };
}
