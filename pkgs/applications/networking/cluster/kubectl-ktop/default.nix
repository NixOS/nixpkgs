{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "kubectl-ktop";
  version = "0.3.5";

  src = fetchFromGitHub {
    owner = "vladimirvivien";
    repo = "ktop";
    rev = "v${version}";
    sha256 = "sha256-nkIRVt2kqsE9QBYvvHmupohnzH+OBcwWwV16rMePw4I=";
  };

  vendorHash = "sha256-IiAMmHOq69WMT2B1q9ZV2fGDnLr7AbRm1P7ACSde2FE=";

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
    description = "A top-like tool for your Kubernetes clusters";
    homepage = "https://github.com/vladimirvivien/ktop";
    changelog = "https://github.com/vladimirvivien/ktop/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = [ maintainers.ivankovnatsky ];
  };
}
